import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:realtime_chat/app/core/constant/colors.dart';
import 'package:realtime_chat/app/modules/chat_page/controllers/chat_page_controller.dart';

import 'chat_list_tile.dart';

class ChatList extends GetView<ChatPageController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: controller.groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: controller.getChatStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  controller.listMessage = snapshot.data!.docs;
                  if (controller.listMessage.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) => ChatListTile(
                        index: index,
                        document: snapshot.data?.docs[index],
                      ),
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                      controller: controller.listScrollController,
                    );
                  } else {
                    return const Center(child: Text("No message here yet..."));
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.themeColor,
                    ),
                  );
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(
                color: AppColor.themeColor,
              ),
            ),
    );
  }
}
