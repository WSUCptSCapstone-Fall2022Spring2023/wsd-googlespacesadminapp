import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spaces_application/data/models/userData.dart';

class SpaceRepository {
  final auth = FirebaseAuth.instance;

  Future<void> createSpace(String name, String description) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    // creates a key for the new space (id)
    final newPostKey = ref.child("Spaces/").push().key;
    // gives the space a name under its key
    await ref
        .child("Spaces/")
        .child(newPostKey!)
        .set({"spaceName": name, "spaceDescription": description});

    // gets currentUser data
    final snapshot =
        await ref.child("UserData/").child(auth.currentUser!.uid).get();
    final currentUser = UserData.fromFirebase(snapshot);

    // stores permissions under both the user and the space
    await ref
        .child("Spaces/")
        .child(newPostKey)
        .child("members/")
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
        .child("spacesJoined/")
        .child(newPostKey)
        .set({
      "canComment": true,
      "canEdit": true,
      "canInvite": true,
      "canRemove": true,
      "canPost": true,
      "canDelete": true
    });
  }
}
