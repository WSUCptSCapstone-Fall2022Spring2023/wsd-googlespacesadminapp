import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:spaces_application/presentation/views/create_spaceView.dart';
import 'package:spaces_application/presentation/views/registerView.dart';

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
        // RepositoryProvider<UserDataRepository>(
        //     create: (context) => UserDataRepository()),
      ],
      child: MaterialApp(
          title: 'Home Page',
          home: LoginView(),
          theme: ThemeData(fontFamily: 'Circular', primarySwatch: Colors.red)),
      //create: (context) => AuthRepository(),
      //child: RegisterView()),
    );
  }
}
