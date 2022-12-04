import 'package:firebase_database/firebase_database.dart';

class UserData {
  String uid = "";
  bool isFaculty = false;
  String email = "";
  String parentEmail = "";
  String firstName = "Ben";
  String lastName = "";
  String displayName = "";
  int grade = 0;

  UserData(this.uid, this.isFaculty, this.email, this.parentEmail,
      this.firstName, this.lastName, this.displayName, this.grade);

  UserData.empty();

  UserData.fromFirebase(DataSnapshot snapshot) {
    uid = snapshot.key as String;
    for (final child in snapshot.children) {
      if (child.key == "isFaculty") {
        isFaculty = child.value as bool;
      } else if (child.key == "email") {
        email = child.value as String;
      } else if (child.key == "parentEmail") {
        parentEmail = child.value as String;
      } else if (child.key == "firstName") {
        firstName = child.value as String;
      } else if (child.key == "lastName") {
        lastName = child.value as String;
      } else if (child.key == "displayName") {
        displayName = child.value as String;
      } else if (child.key == "grade;") {
        //grade = child.value as int;
      } else {
        throw Exception("Invalid data import");
      }
    }
  }

  void toFirebase() {}
}
