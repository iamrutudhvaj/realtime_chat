import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realtime_chat/app/controller/app_controller.dart';
import 'package:realtime_chat/app/core/constant/colors.dart';
import 'package:realtime_chat/app/model/user_model.dart';

import '../../../core/constant/firestore_constants.dart';
import '../../../model/message_chat.dart';
import '../../../routes/app_pages.dart';

class ChatPageController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late UserData peerUserData;
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessage = [];

  final _limit = 20.obs;
  int get limit => _limit.value;
  set limit(int value) => _limit.value = value;

  final int _limitIncrement = 20;
  String groupChatId = "";

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _lastMessage = Rx<MessageChat?>(null);
  MessageChat? get lastMessage => _lastMessage.value;
  set lastMessage(MessageChat? value) => _lastMessage.value = value;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  AppController appController = Get.find<AppController>();

  @override
  void onInit() {
    peerUserData = Get.arguments;
    listScrollController.addListener(_scrollListener);
    readLocal();
    super.onInit();
  }

  _scrollListener() {
    if (!listScrollController.hasClients) return;
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        limit <= listMessage.length) {
      limit += _limitIncrement;
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    updateDataFirestore(
      FirestoreConstants.userCollection,
      currentUserId,
      {FirestoreConstants.chattingWith: null},
    );
    if (lastMessage?.idFrom == currentUserId) {
      appController.firebaseFireStore
          .collection(FirestoreConstants.messageCollection)
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(lastMessage?.timestamp)
          .update({FirestoreConstants.seen: false});
    }
    Get.back();
    return Future.value(false);
  }

  void readLocal() {
    if (firebaseAuth.currentUser?.uid != null) {
      currentUserId = firebaseAuth.currentUser!.uid;
    } else {
      Get.offAllNamed(Routes.LOGIN_PAGE);
    }

    String peerId = peerUserData.id;

    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }

    updateDataFirestore(
      FirestoreConstants.userCollection,
      currentUserId,
      {FirestoreConstants.chattingWith: peerId},
    );
  }

  Future<void> updateDataFirestore(String collectionPath, String docPath,
      Map<String, dynamic> dataNeedUpdate) {
    return appController.firebaseFireStore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getChatStream() {
    return appController.firebaseFireStore
        .collection(FirestoreConstants.messageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      sendMessage(content, type, groupChatId, currentUserId, peerUserData.id);
      if (listScrollController.hasClients) {
        listScrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
      Get.snackbar('Nothing to send', "", backgroundColor: AppColor.greyColor);
    }
  }

  void sendMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) {
    var timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

    DocumentReference documentReference = appController.firebaseFireStore
        .collection(FirestoreConstants.messageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(timeStamp);
    appController.firebaseFireStore
        .collection(FirestoreConstants.userCollection)
        .doc(currentUserId)
        .update({FirestoreConstants.lastChatTimeStamp: timeStamp});
    appController.firebaseFireStore
        .collection(FirestoreConstants.userCollection)
        .doc(peerId)
        .update({FirestoreConstants.lastChatTimeStamp: timeStamp});

    MessageChat messageChat = MessageChat(
      idFrom: currentUserId,
      idTo: peerId,
      timestamp: timeStamp,
      content: content,
      type: type,
      seen: false,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }
}
