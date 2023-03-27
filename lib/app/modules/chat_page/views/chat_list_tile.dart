import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:realtime_chat/app/core/constant/colors.dart';

import '../../../core/constant/firestore_constants.dart';
import '../../../model/message_chat.dart';
import '../controllers/chat_page_controller.dart';

class ChatListTile extends GetView<ChatPageController> {
  const ChatListTile({super.key, required this.index, this.document});
  final int index;
  final DocumentSnapshot? document;

  @override
  Widget build(BuildContext context) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document!);
      controller.lastMessage = messageChat;
      if (controller.lastMessage?.idFrom != controller.currentUserId) {
        controller.appController.firebaseFireStore
            .collection(FirestoreConstants.messageCollection)
            .doc(controller.groupChatId)
            .collection(controller.groupChatId)
            .doc(controller.lastMessage?.timestamp)
            .update({FirestoreConstants.seen: true});
      }
      if (messageChat.idFrom == controller.currentUserId) {
        // Right (my message)
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              width: 200,
              decoration: BoxDecoration(
                  color: AppColor.greyColor2,
                  borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.only(
                  bottom: controller.isLastMessageRight(index) ? 20 : 10,
                  right: 10),
              child: Text(
                messageChat.content ?? '',
                style: const TextStyle(color: AppColor.primaryColor),
              ),
            )
          ],
        );
      } else {
        // Left (peer message)
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  controller.isLastMessageLeft(index)
                      ? Material(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                            controller.peerUserData.photoUrl,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.themeColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, object, stackTrace) {
                              return const Icon(
                                Icons.account_circle,
                                size: 35,
                                color: AppColor.greyColor,
                              );
                            },
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(width: 35),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    width: 200,
                    decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      messageChat.content ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),

              // Time
              controller.isLastMessageLeft(index)
                  ? Container(
                      margin:
                          const EdgeInsets.only(left: 50, top: 5, bottom: 5),
                      child: Text(
                        DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(int.parse(
                                messageChat.timestamp ??
                                    DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString()))),
                        style: const TextStyle(
                            color: AppColor.greyColor,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
