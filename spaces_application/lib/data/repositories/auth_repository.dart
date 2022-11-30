import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthRepository {
  final auth = FirebaseAuth.instance;
  Future<void> login(String email, String password) async {
    print('attempting login');
    await auth.signInWithEmailAndPassword(email: email, password: password);
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/");
    await ref.set({"name": "Ben", "age": 21});
    print('loggin in');
  }

  Future<void> register(String email) async {
    print('attempting register');
    await auth.createUserWithEmailAndPassword(
        email: email, password: "password");

    print('registering');
  }
}
