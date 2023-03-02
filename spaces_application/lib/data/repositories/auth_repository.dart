import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthRepository {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("UserData/");
  late User currentUser;

  Future<void> login(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    String uid = auth.currentUser!.uid;
    // On login, this snippet checks whether the current user exists in the realtime db
    // Since Faculty users are created by direct insertion to auth db, they do not yet exist in the realtime db
    // If the logged in user does not exist in the realtime db, they must be a Faculty user, so the isFaculty field is updated to true
    DataSnapshot snapshot = await ref.child(uid).get();
    // Only triggered when user is not in the realtime db
    if (!snapshot.exists) {
      String profilePic =
          '{"topType":24,"accessoriesType":0,"hairColor":1,"facialHairType":0,"facialHairColor":1,"clotheType":4,"eyeType":6,"eyebrowType":10,"mouthType":8,"skinColor":3,"clotheColor":8,"style":0,"graphicType":0}';
      await ref.child(uid).update(
          {"isFaculty": true, "email": email, 'profilePic': profilePic});
    }

    snapshot = await ref.child(uid).get();
    currentUser = auth.currentUser!;
  }

  Future<void> register(String email, String parentEmail, String firstName,
      String lastName) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    final userCredential = await FirebaseAuth.instanceFor(app: app)
        .createUserWithEmailAndPassword(email: email, password: "password");
    // has to do this in order to create a user without logging in
    await app.delete();
    await auth.sendPasswordResetEmail(email: email);
    String uid = userCredential.user!.uid;
    String displayName = '$firstName $lastName';
    String profilePic =
        '{"topType":24,"accessoriesType":0,"hairColor":1,"facialHairType":0,"facialHairColor":1,"clotheType":4,"eyeType":6,"eyebrowType":10,"mouthType":8,"skinColor":3,"clotheColor":8,"style":0,"graphicType":0}';
    // creates student user instances in realtime db
    // sets isFaculty field to false
    await ref.child(uid).update({
      "isFaculty": false,
      "email": email,
      'parentEmail': parentEmail,
      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName,
      'profilePic': profilePic
    });
  }
}
