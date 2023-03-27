import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:realtime_chat/app/routes/app_pages.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/firestore_constants.dart';
import '../../../model/message_chat.dart';
import '../../../model/user_model.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text(
                          "Are you sure you want to logout?",
                          style: TextStyle(),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              "No",
                              style: TextStyle(),
                            ),
                          ),
                          CupertinoDialogAction(
                            onPressed: () {
                              controller.handleSignOut();
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: controller.getStreamFireStore(
                    FirestoreConstants.userCollection,
                  ),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if ((snapshot.data?.docs.length ?? 0) > 0) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemBuilder: (context, index) {
                            if (snapshot.data?.docs[index].id ==
                                controller.firebaseAuth.currentUser?.uid) {
                              return const SizedBox.shrink();
                            }
                            if (snapshot.data?.docs[index] != null) {
                              return PersonListTile(
                                document: snapshot.data!.docs[index],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          itemCount: snapshot.data?.docs.length,
                        );
                      } else {
                        return const Center(
                          child: Text("No users"),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.themeColor,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class PersonListTile extends GetView<HomeController> {
  const PersonListTile({super.key, required this.document});
  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    UserData peerUserData = UserData.fromDocument(document);
    return StreamBuilder(
      stream: controller.getFirstChatStream(peerId: peerUserData.id),
      builder: (context, snapshot) {
        MessageChat? messageChat;
        if (snapshot.data?.docs.isNotEmpty == true) {
          messageChat = MessageChat.fromDocument(snapshot.data!.docs.first);
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
          child: TextButton(
            onPressed: () {
              Get.toNamed(Routes.CHAT_PAGE, arguments: peerUserData);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  clipBehavior: Clip.hardEdge,
                  child: peerUserData.photoUrl.isNotEmpty
                      ? Image.network(
                          peerUserData.photoUrl,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.themeColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 50,
                              color: AppColor.greyColor,
                            );
                          },
                        )
                      : const Icon(
                          Icons.account_circle,
                          size: 50,
                          color: AppColor.greyColor,
                        ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                          child: Text(
                            peerUserData.name,
                            maxLines: 1,
                            style: const TextStyle(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            if (snapshot.hasError) {
                              return const SizedBox.shrink();
                            }
                            if (snapshot.data?.docs.isNotEmpty == true) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                                child: Text(
                                  "${messageChat?.content}",
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                                child: const Text(
                                  'No message here yet...',
                                  maxLines: 1,
                                  style:
                                      TextStyle(color: AppColor.primaryColor),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (messageChat != null &&
                    messageChat.seen != true &&
                    messageChat.idFrom != controller.currentUserId) ...[
                  Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  )
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
