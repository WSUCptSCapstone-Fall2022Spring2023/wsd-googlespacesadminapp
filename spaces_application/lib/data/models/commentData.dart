import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:spaces_application/data/models/userData.dart';

class CommentData {
  String contents = "";
  UserData commentUser = UserData.empty();
  DateTime postedTime = DateTime.now();

  CommentData(this.contents, this.commentUser, this.postedTime);

  CommentData.empty();

  CommentData.fromFirebase(DataSnapshot snapshot) {
    String timeString = snapshot.key as String;
    postedTime = DateTime.parse(
        timeString.replaceFirst(':', '.', timeString.lastIndexOf(':')));
    contents = snapshot.child('contents/').value as String;
  }
}
