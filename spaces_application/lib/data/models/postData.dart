import 'package:firebase_database/firebase_database.dart';
import 'package:spaces_application/data/models/userData.dart';

class PostData {
  String contents = "";
  UserData postUser = UserData.empty();
  DateTime postedTime = DateTime.now();

  PostData(this.contents, this.postUser, this.postedTime);

  PostData.empty();

  PostData.fromFirebase(DataSnapshot snapshot) {
    String timeString = snapshot.key as String;
    postedTime = DateTime.parse(
        timeString.replaceFirst(':', '.', timeString.lastIndexOf(':')));
    contents = snapshot.child('contents/').value as String;
  }
}
