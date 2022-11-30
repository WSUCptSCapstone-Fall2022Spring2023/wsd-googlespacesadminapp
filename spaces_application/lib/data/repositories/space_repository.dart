import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class SpaceRepository {
  final auth = FirebaseAuth.instance;

  Future<void> createSpace(String name) async {
    var uuid = Uuid();
    DatabaseReference ref = FirebaseDatabase.instance.ref("spaces/");
    await ref.set({
      "spaceName": name,
      "spaceID": uuid.v1(),
      "ownerID": auth.currentUser?.uid
    });
  }
}
