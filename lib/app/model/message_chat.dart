import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constant/firestore_constants.dart';

class MessageChat {
  String? idFrom;
  String? idTo;
  String? timestamp;
  String? content;
  int? type;
  bool? seen;

  MessageChat({
    this.idFrom,
    this.idTo,
    this.timestamp,
    this.content,
    this.type,
    this.seen = true,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idFrom: idFrom,
      FirestoreConstants.idTo: idTo,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.content: content,
      FirestoreConstants.type: type,
      FirestoreConstants.seen: seen,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(FirestoreConstants.idFrom);
    String idTo = doc.get(FirestoreConstants.idTo);
    String timestamp = doc.get(FirestoreConstants.timestamp);
    String content = doc.get(FirestoreConstants.content);
    int type = doc.get(FirestoreConstants.type);
    bool seen = doc.get(FirestoreConstants.seen);
    return MessageChat(
      idFrom: idFrom,
      idTo: idTo,
      timestamp: timestamp,
      content: content,
      type: type,
      seen: seen,
    );
  }
}
