import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constant/firestore_constants.dart';
import '../../../routes/app_pages.dart';

class LoginPageController extends GetxController {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> handleSignIn() async {
    try {
      Get.dialog(const Center(
        child: CircularProgressIndicator(),
      ));
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        User? firebaseUser =
            (await firebaseAuth.signInWithCredential(credential)).user;

        if (firebaseUser != null) {
          final result = await firebaseFirestore
              .collection(FirestoreConstants.userCollection)
              .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
              .get();
          final List<DocumentSnapshot> documents = result.docs;
          if (documents.isEmpty) {
            // Writing data to server because here is a new user
            firebaseFirestore
                .collection(FirestoreConstants.userCollection)
                .doc(firebaseUser.uid)
                .set({
              FirestoreConstants.nickname: firebaseUser.displayName,
              FirestoreConstants.photoUrl: firebaseUser.photoURL,
              FirestoreConstants.id: firebaseUser.uid,
              'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
              FirestoreConstants.lastChatTimeStamp: '0',
              FirestoreConstants.chattingWith: null
            });
          }
          Get.back();
          Get.offAllNamed(Routes.HOME);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
