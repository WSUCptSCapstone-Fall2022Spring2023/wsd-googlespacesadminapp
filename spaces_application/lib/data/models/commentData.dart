import 'package:firebase_database/firebase_database.dart';
import 'package:spaces_application/data/models/userData.dart';

class CommentData {
  String contents = "";
  UserData commentUser = UserData.empty();
  DateTime commentedTime = DateTime.now();

  CommentData(this.contents, this.commentUser, this.commentedTime);

  CommentData.empty();

  CommentData.fromFirebase(DataSnapshot snapshot) {
    String timeString = snapshot.key as String;
    commentedTime = DateTime.parse(
        timeString.replaceFirst(':', '.', timeString.lastIndexOf(':')));
    contents = snapshot.child('contents/').value as String;
  }
}
