import 'package:firebase_database/firebase_database.dart';
import 'package:spaces_application/data/models/userData.dart';

class PostData {
  String contents = "";
  UserData postUser = UserData.empty();
  DateTime postedTime = DateTime.now();

  PostData(this.contents, this.postUser, this.postedTime);

  PostData.empty();

  PostData.fromSpace(DataSnapshot snapshot) {
    postedTime = DateTime.parse(snapshot.key as String);
    for (final child in snapshot.children) {
      if (child.key == "userID") {
        postUser = UserData.fromFirebase(child);
      } else if (child.key == "contents") {
        contents = child.value as String;
      } else {
        throw Exception("Invalid PostData import");
      }
    }
  }
}
