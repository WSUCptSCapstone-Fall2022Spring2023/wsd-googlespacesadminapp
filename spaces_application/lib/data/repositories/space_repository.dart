import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';

import '../models/commentData.dart';
import '../models/postData.dart';

class SpaceRepository {
  final auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> createSpace(String name, String description) async {
    // creates a key for the new space (id)
    final newSpaceKey = ref.child("Spaces/").push().key;
    // gives the space a name under its key
    await ref
        .child("Spaces/")
        .child(newSpaceKey!)
        .set({"spaceName": name, "spaceDescription": description});

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
    final timeStr = currentTime.toString().replaceAll('.', ':');
    await ref
        .child("Posts/")
        .child(spaceID)
        .child(timeStr)
        .set({"userID": userID, "contents": message, "isEdited": false});
  }

  Future<void> deletePost(
      DateTime postTime, String spaceID, String postAuthorID) async {
    final timeStr = postTime.toString().replaceAll('.', ':');
    await ref.child("Posts/").child(spaceID).child(timeStr).remove();
    await ref.child("Comments/").child(postAuthorID).child(timeStr).remove();
  }

  // returns a list of spaces searched for by spacesJoined field in UserData

  Future<PostData> getPost(DataSnapshot snapshot) async {
    PostData post = PostData.fromFirebase(snapshot);
    String uid = snapshot.child("userID/").value as String;
    DataSnapshot userSnapshot = await ref.child("UserData/").child(uid).get();
    post.postUser = UserData.fromFirebase(userSnapshot);
    final commentSnapshot = await ref
        .child('Comments/')
        .child(post.postUser.uid)
        .child(post.postedTime.toString().replaceAll('.', ':'))
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

  Future<void> changePermissions(String spaceID, String userID, bool canComment,
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

  Future<void> removeUserFromSpace(String spaceID, String userID) async {
    await ref
        .child("UserData/")
        .child(userID)
        .child("spacePermissions/")
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

  Future<void> editPost(
      DateTime postedDate, String newContents, String spaceID) async {
    final postTimeStr = postedDate.toString().replaceAll('.', ':');
    await ref
        .child("Posts/")
        .child(spaceID)
        .child(postTimeStr)
        .update({'contents': newContents, 'isEdited': true});
  }

  Future<void> editComment(DateTime commentDate, DateTime postDate,
      String newContents, String posterID) async {
    final postTimeStr = postDate.toString().replaceAll('.', ':');
    final commentTimeStr = commentDate.toString().replaceAll('.', ':');
    await ref
        .child("Comments/")
        .child(posterID)
        .child(postTimeStr)
        .child(commentTimeStr)
        .update({"contents": newContents});
  }

  Future<void> deleteComment(
      DateTime commentDate, DateTime postDate, String posterID) async {
    final postTimeStr = postDate.toString().replaceAll('.', ':');
    await ref.child("Comments/").child(posterID).child(postTimeStr).remove();
  }
}
