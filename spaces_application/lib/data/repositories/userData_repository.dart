import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spaces_application/data/models/spaceData.dart';
import 'package:spaces_application/data/models/userData.dart';

class UserDataRepository {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref();
  late UserData currentUserData;

  // retrieves current userdata from firebase
  Future<UserData> getCurrentUserData() async {
    String uid = auth.currentUser!.uid;
    DataSnapshot snapshot = await ref.child("UserData/").child(uid).get();
    UserData currentUser = UserData.fromFirebase(snapshot);

    // retrieves spaceData of spaces current user is a member of
    List<SpaceData> spacesJoined = [];
    for (final space in currentUser.spacesPermissions) {
      spacesJoined.add(await getSpaceData(space.spaceID));
    }
    currentUser.spacesJoined = spacesJoined;
    currentUserData = currentUser;
    return currentUser;
  }

  Future<void> setCurrentUserData(
      String firstName, String lastName, String displayName) async {
    await ref.child(currentUserData.uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName
    });
  }

  // returns a space searched for by ID
  Future<SpaceData> getSpaceData(String spaceID) async {
    final snapshot = await ref.child("Spaces/").child(spaceID).get();
    final space = SpaceData.fromFirebase(snapshot);
    return space;
  }
}
