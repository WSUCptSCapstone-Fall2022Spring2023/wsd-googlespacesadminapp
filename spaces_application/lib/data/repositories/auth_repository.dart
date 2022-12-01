import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthRepository {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("users/");

  Future<void> login(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    String uid = auth.currentUser!.uid;

    // On login, this snippet checks whether the current user exists in the realtime db
    // Since Faculty users are created by direct insertion to auth db, they do not yet exist in the realtime db
    // If the logged in user does not exist in the realtime db, they must be a Faculty user, so the isFaculty field is updated to true
    final snapshot = await ref.child(uid).get();
    if (!snapshot.exists) {
      await ref.child(uid).update({"email": email, "isFaculty": true});
    }
  }

  Future<void> register(String email) async {
    final userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: "password");
    String uid = userCredential.user!.uid;
    // creates student user instances in realtime db
    // sets isFaculty field to false
    await ref.child(uid).update({"email": email, "isFaculty": false});
  }
}
