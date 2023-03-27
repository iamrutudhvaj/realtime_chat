import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constant/firestore_constants.dart';

class UserData {
  String id;
  String photoUrl;
  String name;
  String aboutMe;

  UserData(
      {required this.id,
      required this.photoUrl,
      required this.name,
      required this.aboutMe});

  Map<String, String> toJson() {
    return {
      FirestoreConstants.nickname: name,
      FirestoreConstants.aboutMe: aboutMe,
      FirestoreConstants.photoUrl: photoUrl,
    };
  }

  factory UserData.fromDocument(DocumentSnapshot doc) {
    String aboutMe = "";
    String photoUrl = "";
    String name = "";
    try {
      aboutMe = doc.get(FirestoreConstants.aboutMe);
    } catch (e) {}
    try {
      photoUrl = doc.get(FirestoreConstants.photoUrl);
    } catch (e) {}
    try {
      name = doc.get(FirestoreConstants.nickname);
    } catch (e) {}
    return UserData(
      id: doc.id,
      photoUrl: photoUrl,
      name: name,
      aboutMe: aboutMe,
    );
  }
}
