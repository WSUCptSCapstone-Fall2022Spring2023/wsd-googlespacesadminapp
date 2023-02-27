import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';

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
      "canDelete": true
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
      "canDelete": true
    });
  }

  Future<void> createPost(String message, String userID, String spaceID) async {
    final currentTime = DateTime.now().toString().replaceAll('.', ':');
    await ref
        .child("Posts/")
        .child(spaceID)
        .child(currentTime)
        .set({"userID": userID, "contents": message});
  }

  // returns a list of spaces searched for by spacesJoined field in UserData

  Future<PostData> getPost(DataSnapshot snapshot) async {
    PostData post = PostData.fromFirebase(snapshot);
    String uid = snapshot.child("userID/").value as String;
    DataSnapshot userSnapshot = await ref.child("UserData/").child(uid).get();
    post.postUser = UserData.fromFirebase(userSnapshot);
    return post;
  }

  Future<List<PostData>> getSpacePosts(String spaceID) async {
    final snapshot = await ref.child("Posts/").child(spaceID).get();
    List<PostData> spacePosts = List<PostData>.empty(growable: true);
    for (final post in snapshot.children) {
      spacePosts.add(await getPost(post));
    }
    return spacePosts;
  }
}
