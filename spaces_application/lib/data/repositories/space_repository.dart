import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spaces_application/data/models/userData.dart';

class SpaceRepository {
  final auth = FirebaseAuth.instance;

  Future<void> createSpace(String name) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Spaces/");

    final newPostKey = ref.push().key;
    await ref.child(newPostKey!).set({"spaceName": name});

    final snapshot = await ref.child(auth.currentUser!.uid).get();
    final currentUser = UserData.fromFirebase(snapshot);
    await ref
        .child(newPostKey)
        .child("users")
        .set({currentUser.uid: currentUser.isFaculty});
  }
}
