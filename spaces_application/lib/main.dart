import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:spaces_application/presentation/widgets/createSpacePopUpDialog.dart';
import 'package:spaces_application/presentation/widgets/createStudentPopUpDialog.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'data/repositories/space_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color darkViolet = Color.fromARGB(255, 9, 5, 5);
  final Color navyBlue = Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = Color.fromARGB(255, 45, 40, 138);
  final Color majorelleBlue = Color.fromARGB(255, 86, 85, 221);
  final Color salmon = Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = Color.fromARGB(255, 22, 12, 113);
  final Color lightPink = Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = Color.fromARGB(255, 255, 255, 240);

  @override
  Widget build(BuildContext context) {
    bool con = true;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository()),
        RepositoryProvider<SpaceRepository>(
            create: (context) => SpaceRepository()),
        RepositoryProvider<UserDataRepository>(
            create: (context) => UserDataRepository()),
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
