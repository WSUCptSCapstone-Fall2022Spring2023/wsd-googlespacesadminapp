import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/login/login_bloc.dart';
import 'package:spaces_application/business_logic/auth/login/login_event.dart';
import 'package:spaces_application/business_logic/auth/login/login_state.dart';
import 'package:spaces_application/data/models/spaceData.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/presentation/widgets/navigation_drawer.dart';

class ProfileView extends StatelessWidget {
  final Color darkViolet = const Color.fromARGB(255, 9, 5, 5);
  final Color navyBlue = const Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = const Color.fromARGB(255, 45, 40, 138);
  final Color majorelleBlue = const Color.fromARGB(255, 86, 85, 221);
  final Color salmon = const Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = const Color.fromARGB(255, 22, 12, 113);
  final Color lightPink = const Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = const Color.fromARGB(255, 255, 255, 240);

  @override
  Widget build(BuildContext context) {
    UserData currentUser =
        context.read<AuthRepository>().currentUser as UserData;
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: NavigationDrawer(),
        appBar: AppBar(
          elevation: 15,
          title: const Text("Your Profile Page"),
          backgroundColor: navyBlue,
        ),
        body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: <Widget>[
              Icon(Icons.account_circle, size: 150, color: salmon),
              const SizedBox(height: 15),
              Text("${currentUser.firstName} ${currentUser.lastName}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(currentUser.email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 10),
              Text("Display Name: ${currentUser.displayName}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(height: 0),
              ),
              const SizedBox(height: 15),
              const Text("Your Spaces:", textAlign: TextAlign.center),
              const SizedBox(height: 10),
              // Here we have some loop that iterates through each space the user is in, displaying space name and space description
              // foreach (space in currentUser.spaces)
              // {
              //    ListTile(
              //      title: const Text(
              //        space.spaceName,
              //        style: TextStyle(
              //          color: Colors.black,
              //          fontWeight: FontWeight.bold)),
              //      subtitle: const Text(
              //        space.spaceDescription,
              //        style: TextStyle(
              //          color: Colors.black,
              //          fontWeight: FontWeight.normal))),
              //    const SizedBox(height: 10),
              // }
            ]));
  }
}
