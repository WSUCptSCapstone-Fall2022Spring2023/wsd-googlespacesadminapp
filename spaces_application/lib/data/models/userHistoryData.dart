import 'dart:core';

import 'package:firebase_database/firebase_database.dart';
import 'package:spaces_application/data/models/permissionData.dart';
import 'package:spaces_application/data/models/spaceData.dart';

class UserHistoryData {
  String spaceName = "";
  String postedTime = "";
  String contents = "";
  bool isComment = false;

  UserHistoryData.fromFirebase(DataSnapshot snapshot, String name) {
    spaceName = name;
    postedTime = snapshot.key.toString();
    contents = snapshot.child("contents/").value as String;
    isComment = snapshot.child("isComment/").value as bool;
  }
}
