import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:realtime_chat/app/controller/app_controller.dart';
import 'package:realtime_chat/app/core/constant/firestore_constants.dart';
import 'package:realtime_chat/app/routes/app_pages.dart';

class HomeController extends GetxController {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  AppController appController = Get.find<AppController>();
  late String currentUserId;

  @override
  void onInit() {
    currentUserId = firebaseAuth.currentUser!.uid;
    super.onInit();
  }

  Future<void> handleSignOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    Get.offNamedUntil(Routes.LOGIN_PAGE, (route) => false);
  }

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getStreamFireStore(String collection) {
    return firebaseFirestore
        .collection(collection)
        .orderBy(FirestoreConstants.lastChatTimeStamp, descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getFirstChatStream({required String peerId}) {
    var groupChatId = '';
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
    return appController.firebaseFireStore
        .collection(FirestoreConstants.messageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(1)
        .snapshots();
  }
}
