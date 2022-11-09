import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final auth = FirebaseAuth.instance;
  Future<void> login(String email, String password) async {
    print('attempting login');
    await auth.signInWithEmailAndPassword(email: email, password: password);
    print('loggin in');
  }

  Future<void> register(String email) async {
    print('attempting register');
    await auth.createUserWithEmailAndPassword(
        email: email, password: "password");
    print('registering');
  }
}
