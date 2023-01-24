import 'package:firebase_database/firebase_database.dart';

class PermissionData {
  String spaceID = "";
  String userID = "";
  bool canComment = false;
  bool canDelete = false;
  bool canEdit = false;
  bool canInvite = false;
  bool canPost = false;
  bool canRemove = false;

  PermissionData(this.spaceID, this.userID, this.canComment, this.canDelete,
      this.canEdit, this.canInvite, this.canPost, this.canRemove);

  PermissionData.empty();

  // Retrieves PermissionData from a space. This keeps spaceID empty since it was already retrieved
  PermissionData.fromSpace(DataSnapshot permission) {
    userID = permission.key as String;
    for (final child in permission.children) {
      if (child.key == "canComment") {
        canComment = child.value as bool;
      } else if (child.key == "canDelete") {
        canDelete = child.value as bool;
      } else if (child.key == "canEdit") {
        canEdit = child.value as bool;
      } else if (child.key == "canInvite") {
        canInvite = child.value as bool;
      } else if (child.key == "canPost") {
        canPost = child.value as bool;
      } else if (child.key == "canRemove") {
        canRemove = child.value as bool;
      } else {
        throw Exception("Invalid PermissionData import");
      }
    }
  }

// Retrieves PermissionData from a user. This keeps userID empty since it was already retrieved
  PermissionData.fromUser(DataSnapshot permission) {
    spaceID = permission.key as String;
    for (final child in permission.children) {
      if (child.key == "canComment") {
        canComment = child.value as bool;
      } else if (child.key == "canDelete") {
        canDelete = child.value as bool;
      } else if (child.key == "canEdit") {
        canEdit = child.value as bool;
      } else if (child.key == "canInvite") {
        canInvite = child.value as bool;
      } else if (child.key == "canPost") {
        canPost = child.value as bool;
      } else if (child.key == "canRemove") {
        canRemove = child.value as bool;
      } else {
        throw Exception("Invalid PermissionData import");
      }
    }
  }

  void toFirebase() {}
}
