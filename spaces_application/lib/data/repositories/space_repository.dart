import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spaces_application/data/models/permissionData.dart';
import 'package:spaces_application/data/models/spaceData.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/data/models/userHistoryData.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';

import '../models/commentData.dart';
import '../models/postData.dart';

class SpaceRepository {
  final auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> createSpace(
      String name, String description, bool isPrivate) async {
    // creates a key for the new space (id)
    final newSpaceKey = ref.child("Spaces/").push().key;
    // gives the space a name under its key
    await ref.child("Spaces/").child(newSpaceKey!).set({
      "spaceName": name,
      "spaceDescription": description,
      "isPrivate": isPrivate
    });

    // gets currentUser data
    final snapshot =
        await ref.child("UserData/").child(auth.currentUser!.uid).get();
    final currentUser = UserData.fromFirebase(snapshot);

    // stores permissions under both the user and the space
    await ref
        .child("Spaces/")
        .child(newSpaceKey)
        .child("membersPermissions/")
        .child(currentUser.uid)
        .set({
      "canComment": true,
      "canEdit": true,
      "canInvite": true,
      "canRemove": true,
      "canPost": true,
    });

    await ref
        .child("UserData/")
        .child(currentUser.uid)
        .child("spacesPermissions/")
        .child(newSpaceKey)
        .set({
      "canComment": true,
      "canEdit": true,
      "canInvite": true,
      "canRemove": true,
      "canPost": true,
    });
  }

  Future<void> createPost(String message, String userID, String spaceID,
      DateTime currentTime) async {
    final permissions = await getPermissions(userID, spaceID);
    if (permissions.canPost) {
      final timeStr = currentTime.toString().replaceAll('.', ':');
      await ref
          .child("Posts/")
          .child(spaceID)
          .child(timeStr)
          .set({"userID": userID, "contents": message, "isEdited": false});
      await ref
          .child("UserHistory/")
          .child(currentTime.year.toString())
          .child(currentTime.month.toString())
          .child(userID)
          .child(spaceID)
          .child(timeStr)
          .set({"contents": message, "isComment": false});
    } else {
      throw Exception(
          "You do not have permission to do that. Please contact a Space Administrator.");
    }
  }

  Future<void> deletePost(String userID, DateTime postTime, String spaceID,
      String postAuthorID) async {
    final permissions = await getPermissions(userID, spaceID);
    if (permissions.canRemove || userID == postAuthorID) {
      final timeStr = postTime.toString().replaceAll('.', ':');
      await ref.child("Posts/").child(spaceID).child(timeStr).remove();
      await ref.child("Comments/").child(postAuthorID).child(timeStr).remove();
    } else {
      throw Exception(
          "You do not have permission to do that. Please contact a Space Administrator.");
    }
  }

  // returns a list of spaces searched for by spacesJoined field in UserData

  Future<PostData> getPost(DataSnapshot snapshot) async {
    PostData post = PostData.fromFirebase(snapshot);
    String uid = snapshot.child("userID/").value as String;
    DataSnapshot userSnapshot = await ref.child("UserData/").child(uid).get();
    post.postUser = UserData.fromFirebase(userSnapshot);
    final timeStr = post.postedTime.toString().replaceAll('.', ':');
    final commentSnapshot = await ref
        .child('Comments/')
        .child(post.postUser.uid)
        .child(timeStr)
        .get();
    post.commentCount = commentSnapshot.children.length;
    return post;
  }

  Future<List<PostData>> getSpacePosts(String spaceID) async {
    final postRef =
        FirebaseDatabase.instance.ref("Posts/").child(spaceID).limitToLast(15);
    final postSnapshot = await postRef.get();
    List<PostData> spacePosts = List<PostData>.empty(growable: true);
    for (final post in postSnapshot.children) {
      spacePosts.add(await getPost(post));
    }
    return spacePosts;
  }

  Future<List<PostData>> getMoreSpacePosts(
      String spaceID, DateTime lastPost) async {
    final postRef = FirebaseDatabase.instance
        .ref("Posts/")
        .child(spaceID)
        .orderByKey()
        .endBefore(lastPost.toString().replaceAll('.', ':'))
        .limitToLast(15);
    final postSnapshot = await postRef.get();
    List<PostData> spacePosts = List<PostData>.empty(growable: true);
    final numPosts = postSnapshot.children.length;
    for (final post in postSnapshot.children) {
      if (numPosts == 1) {
        final newPost = await getPost(post);
        if (newPost.postedTime == lastPost) {
          return spacePosts;
        }
      }
      spacePosts.add(await getPost(post));
    }
    return spacePosts;
  }

  Future<List<PostData>> getNewPosts(String spaceID, DateTime lastPost) async {
    final postRef = FirebaseDatabase.instance
        .ref("Posts/")
        .child(spaceID)
        .orderByKey()
        .startAfter(lastPost.toString().replaceAll('.', ':'));
    final postSnapshot = await postRef.get();
    List<PostData> spacePosts = List<PostData>.empty(growable: true);
    final numPosts = postSnapshot.children.length;
    for (final post in postSnapshot.children) {
      spacePosts.add(await getPost(post));
    }
    return spacePosts;
  }

  Future<UserData> getUserFromID(String userID) async {
    final snapshot = await ref.child("UserData/").child(userID).get();
    UserData user = UserData.fromFirebase(snapshot);
    return user;
  }

  Future<List<UserData>> getUsersInSpace(String spaceID) async {
    final snapshot = await ref
        .child("Spaces/")
        .child(spaceID)
        .child("membersPermissions/")
        .get();
    final List<UserData> users = List<UserData>.empty(growable: true);
    for (final child in snapshot.children) {
      UserData user = await getUserFromID(child.key as String);
      users.add(user);
    }
    return users;
  }

  Future<List<SpaceData>> getAllSpaces() async {
    List<SpaceData> publicSpaces = List<SpaceData>.empty(growable: true);
    final snapshot = await ref.child("Spaces/").get();
    for (final child in snapshot.children) {
      final space = SpaceData.fromFirebase(child);
      publicSpaces.add(space);
    }
    return publicSpaces;
  }

  // deletes Space from db
  Future<void> deleteSpace(String spaceID) async {
    // gets list of all users within the space
    final snapshot = await ref
        .child("Spaces/")
        .child(spaceID)
        .child("membersPermissions/")
        .get();
    final List<String> userIDs = List<String>.empty(growable: true);
    for (final child in snapshot.children) {
      userIDs.add(child.key as String);
    }
    // iterates through users list and deletes the space info from within them
    for (final userID in userIDs) {
      await ref
          .child("UserData/")
          .child(userID)
          .child("spacesPermissions/")
          .child(spaceID)
          .remove();
    }
    // removes space from Spaces
    await ref.child("Spaces/").child(spaceID).remove();
    // removes posts from Spaces
    await ref.child("Posts/").child(spaceID).remove();
  }

  Future<void> changePrivacy(String spaceID, bool isPrivate) async {
    await ref.child("Spaces/").child(spaceID).update({"isPrivate": isPrivate});
  }

  Future<void> joinSpace(String spaceID, List<UserData> users) async {
    for (final user in users) {
      if (user.isFaculty) {
        await ref
            .child("Spaces/")
            .child(spaceID)
            .child("membersPermissions/")
            .child(user.uid)
            .set({
          "canComment": true,
          "canEdit": true,
          "canInvite": true,
          "canRemove": true,
          "canPost": true,
        });

        await ref
            .child("UserData/")
            .child(user.uid)
            .child("spacesPermissions/")
            .child(spaceID)
            .set({
          "canComment": true,
          "canEdit": true,
          "canInvite": true,
          "canRemove": true,
          "canPost": true,
        });
      } else {
        await ref
            .child("Spaces/")
            .child(spaceID)
            .child("membersPermissions/")
            .child(user.uid)
            .set({
          "canComment": true,
          "canEdit": false,
          "canInvite": false,
          "canRemove": false,
          "canPost": true,
        });

        await ref
            .child("UserData/")
            .child(user.uid)
            .child("spacesPermissions/")
            .child(spaceID)
            .set({
          "canComment": true,
          "canEdit": false,
          "canInvite": false,
          "canRemove": false,
          "canPost": true,
        });
      }
    }
  }

  Future<void> updatePermissions(String spaceID, String userID, bool canComment,
      bool canEdit, bool canInvite, bool canRemove, bool canPost) async {
    await ref
        .child("UserData/")
        .child(userID)
        .child("spacesPermissions/")
        .child(spaceID)
        .update({
      "canComment": canComment,
      "canEdit": canEdit,
      "canInvite": canInvite,
      "canRemove": canRemove,
      "canPost": canPost,
    });

    await ref
        .child("Spaces/")
        .child(spaceID)
        .child("membersPermissions/")
        .child(userID)
        .update({
      "canComment": canComment,
      "canEdit": canEdit,
      "canInvite": canInvite,
      "canRemove": canRemove,
      "canPost": canPost,
    });
  }

  Future<PermissionData> getPermissions(String userID, String spaceID) async {
    final snapshot = await ref
        .child("UserData/")
        .child(userID)
        .child("spacesPermissions/")
        .child(spaceID)
        .get();
    PermissionData permissions = PermissionData.fromUser(snapshot);
    return permissions;
  }

  Future<void> removeUserFromSpace(String spaceID, String userID) async {
    await ref
        .child("UserData/")
        .child(userID)
        .child("spacesPermissions/")
        .child(spaceID)
        .remove();

    await ref
        .child("Spaces/")
        .child(spaceID)
        .child("membersPermissions/")
        .child(userID)
        .remove();
  }

  Future<void> createComment(
      String message,
      String postAuthorID,
      String commenterID,
      String spaceID,
      DateTime postDate,
      DateTime currentTime) async {
    final permissions = await getPermissions(commenterID, spaceID);
    if (permissions.canComment) {
      final timeStr = currentTime.toString().replaceAll('.', ':');
      final postDateStr = postDate.toString().replaceAll('.', ':');
      await ref
          .child("Comments/")
          .child(postAuthorID)
          .child(postDateStr)
          .child(timeStr)
          .set({
        "spaceID": spaceID,
        "contents": message,
        "commenter": commenterID,
        "isEdited": false
      });
      await ref
          .child("UserHistory/")
          .child(currentTime.year.toString())
          .child(currentTime.month.toString())
          .child(commenterID)
          .child(spaceID)
          .child(timeStr)
          .set({"contents": message, "isComment": true});
    } else {
      throw Exception(
          "You do not have permission to do that. Please contact a Space Administrator.");
    }
  }

  Future<CommentData> getComment(DataSnapshot snapshot) async {
    CommentData comment = CommentData.fromFirebase(snapshot);
    String commenterID = snapshot.child("commenter").value as String;
    DataSnapshot userSnapshot =
        await ref.child("UserData/").child(commenterID).get();
    comment.commentUser = UserData.fromFirebase(userSnapshot);
    return comment;
  }

  Future<List<CommentData>> getPostComments(
      String postAuthorID, DateTime postDate) async {
    final postDateStr = postDate.toString().replaceAll('.', ':');
    final commentSnapshot = await ref
        .child("Comments/")
        .child(postAuthorID)
        .child(postDateStr)
        .get();
    List<CommentData> postComments = List<CommentData>.empty(growable: true);
    for (final comment in commentSnapshot.children) {
      postComments.add(await getComment(comment));
    }
    return postComments;
  }

  Future<DatabaseReference> getSpaceReference(String spaceID) async {
    DatabaseReference spaceRef =
        FirebaseDatabase.instance.ref("Posts/$spaceID");
    return spaceRef;
  }

  Future<void> editPost(String userID, DateTime postedDate, String newContents,
      String spaceID) async {
    final permissions = await getPermissions(userID, spaceID);
    final postTimeStr = postedDate.toString().replaceAll('.', ':');
    final posterID = await ref
        .child("Posts/")
        .child(spaceID)
        .child(postTimeStr)
        .child("userID")
        .get();
    if (permissions.canEdit || posterID.value == userID) {
      await ref
          .child("Posts/")
          .child(spaceID)
          .child(postTimeStr)
          .update({'contents': newContents, 'isEdited': true});
      await ref
          .child("UserHistory/")
          .child(postedDate.year.toString())
          .child(postedDate.month.toString())
          .child(posterID.value as String)
          .child(spaceID)
          .child(postTimeStr)
          .update({"contents": newContents});
    } else {
      throw Exception(
          "You do not have permission to do that. Please contact a Space Administrator.");
    }
  }

  Future<void> editComment(String userID, String spaceID, DateTime commentDate,
      DateTime postDate, String newContents, String posterID) async {
    final permissions = await getPermissions(userID, spaceID);
    final postTimeStr = postDate.toString().replaceAll('.', ':');
    final commentTimeStr = commentDate.toString().replaceAll('.', ':');
    final commenterID = await ref
        .child("Comments/")
        .child(posterID)
        .child(postTimeStr)
        .child(commentTimeStr)
        .child("commenter")
        .get();
    if (permissions.canEdit || commenterID.value == userID) {
      await ref
          .child("Comments/")
          .child(posterID)
          .child(postTimeStr)
          .child(commentTimeStr)
          .update({"contents": newContents});
      await ref
          .child("UserHistory/")
          .child(commentDate.year.toString())
          .child(commentDate.month.toString())
          .child(commenterID.value as String)
          .child(spaceID)
          .child(commentTimeStr)
          .update({"contents": newContents});
    } else {
      throw Exception(
          "You do not have permission to do that. Please contact a Space Administrator.");
    }
  }

  Future<void> deleteComment(String userID, spaceID, DateTime commentDate,
      DateTime postDate, String posterID) async {
    final permissions = await getPermissions(userID, spaceID);
    final postTimeStr = postDate.toString().replaceAll('.', ':');
    final commentTimeStr = commentDate.toString().replaceAll('.', ':');
    final commenterID = await ref
        .child("Comments/")
        .child(posterID)
        .child(postTimeStr)
        .child(commentTimeStr)
        .child("commenter")
        .get();
    if (permissions.canRemove || commenterID.value == userID) {
      await ref
          .child("Comments/")
          .child(posterID)
          .child(postTimeStr)
          .child(commentTimeStr)
          .remove();
    } else {
      throw Exception(
          "You do not have permission to do that. Please contact a Space Administrator.");
    }
  }

  // last month
  Future<List<UserHistoryData>> getUserPostHistory(
      String userID, String selectedMonth, String selectedYear) async {
    List<UserHistoryData> userHistory =
        List<UserHistoryData>.empty(growable: true);
    final snapshot = await ref
        .child("UserHistory/")
        .child(selectedYear)
        .child(selectedMonth)
        .child(userID)
        .get();
    for (final child in snapshot.children) {
      final s2 = await ref
          .child("Spaces/")
          .child(child.key.toString())
          .child("spaceName/")
          .get();
      final spaceName = s2.value as String;
      for (final child2 in child.children) {
        UserHistoryData historyEntry =
            UserHistoryData.fromFirebase(child2, spaceName);
        userHistory.add(historyEntry);
      }
    }
    return userHistory;
  }

  Future<List<String>> getYearHistoryOptions() async {
    final snapshot = await ref.child("UserHistory/").get();
    List<String> years = List<String>.empty(growable: true);
    for (final child in snapshot.children) {
      years.add(child.value as String);
    }
    return years;
  }

  Future<List<String>> getMonthHistoryOptions(String year) async {
    final snapshot = await ref.child("UserHistory/").child(year).get();
    List<String> months = List<String>.empty(growable: true);
    for (final child in snapshot.children) {
      months.add(child.value as String);
    }
    return months;
  }
}
