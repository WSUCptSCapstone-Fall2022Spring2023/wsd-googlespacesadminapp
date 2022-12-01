import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/repositories/space_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool con = true;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository()),
        RepositoryProvider<SpaceRepository>(
            create: (context) => SpaceRepository()),
      ],
      child: MaterialApp(
          title: 'Home Page',
          home: LoginView(),
          theme: ThemeData(fontFamily: 'Circular')),
      //create: (context) => AuthRepository(),
      //child: RegisterView()),
    );
  }
}
