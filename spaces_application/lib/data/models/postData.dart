import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:spaces_application/data/models/userData.dart';

import 'commentData.dart';

class PostData {
  String contents = "";
  UserData postUser = UserData.empty();
  DateTime postedTime = DateTime.now();
  List<CommentData> comments = List<CommentData>.empty(growable: true);
  int commentCount = 0;
  bool isEdited = false;

  PostData(this.contents, this.postUser, this.postedTime, this.commentCount);

  PostData.empty();

  PostData.fromFirebase(DataSnapshot postSnapshot) {
    String timeString = postSnapshot.key as String;
    postedTime = DateTime.parse(
        timeString.replaceFirst(':', '.', timeString.lastIndexOf(':')));
    contents = postSnapshot.child('contents/').value as String;
    isEdited = postSnapshot.child('isEdited/').value as bool;
  }
}
