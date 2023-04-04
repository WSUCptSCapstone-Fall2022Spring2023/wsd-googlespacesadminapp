import 'package:firebase_database/firebase_database.dart';
import 'package:spaces_application/data/models/permissionData.dart';
import 'package:spaces_application/data/models/postData.dart';

class SpaceData {
  String sid = "";
  String spaceDescription = "";
  String spaceName = "";
  List<PermissionData> membersPermissions =
      List<PermissionData>.empty(growable: true);
  bool isPrivate = true;

  List<PostData> spacePosts = List<PostData>.empty(growable: true);

  SpaceData(this.sid, this.spaceDescription, this.spaceName, this.isPrivate);

  SpaceData.empty();

  SpaceData.fromFirebase(DataSnapshot snapshot) {
    sid = snapshot.key as String;
    for (final child in snapshot.children) {
      if (child.key == "spaceName") {
        spaceName = child.value as String;
      } else if (child.key == "spaceDescription") {
        spaceDescription = child.value as String;
      } else if (child.key == "isPrivate") {
        isPrivate = child.value as bool;
      } else if (child.key == "membersPermissions") {
        for (final permission in child.children) {
          membersPermissions.add(PermissionData.fromSpace(permission));
        }
      } else {
        throw Exception("Invalid UserData import");
      }
    }
  }

  void toFirebase() {}
}
