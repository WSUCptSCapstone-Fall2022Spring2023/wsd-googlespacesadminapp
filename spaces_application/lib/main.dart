import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/views/registerView.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Home Page',
        home: RepositoryProvider(
            create: (context) => AuthRepository(), child: LoginView()),
        //create: (context) => AuthRepository(),
        //child: RegisterView()),
        theme: ThemeData(fontFamily: 'Circular'));
  }
}
