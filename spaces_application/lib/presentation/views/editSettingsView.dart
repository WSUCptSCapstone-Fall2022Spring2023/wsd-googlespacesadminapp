import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/presentation/views/profileView.dart';
import 'package:spaces_application/presentation/views/settingsView.dart';
import 'package:spaces_application/presentation/widgets/createSpacePopUpDialog.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/helpPopUpDialog.dart';
import 'package:spaces_application/presentation/widgets/createStudentPopUpDialog.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:spaces_application/presentation/widgets/navigation_drawer.dart';
import '../../data/repositories/userData_repository.dart';
import '../views/edit_profileView.dart';
import '../views/spaceView.dart';
import 'dart:math';

import '../../data/models/userData.dart';

class EditSettingsView extends StatelessWidget {
  EditSettingsView({required this.currentUserData});
  final UserData currentUserData;
  final Color bgColor = const Color.fromARGB(255, 49, 49, 49);
  final Color textColor = const Color.fromARGB(255, 255, 255, 240);
  final Color boxColor = const Color.fromARGB(255, 60, 60, 60);
  final Color offWhite = const Color.fromARGB(255, 244, 244, 244);

  @override
  Widget build(BuildContext context) {
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: offWhite,
        drawer: MyNavigationDrawer(
          currentUserData: currentUserData,
        ),
        appBar: AppBar(
            elevation: 15,
            title: const Text("Edit Settings"),
            backgroundColor: bgColor),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.string(
                            FluttermojiFunctions().decodeFluttermojifromString(
                                currentUserData.profilePicString),
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "${currentUserData.firstName} ${currentUserData.lastName}'s Settings",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 35)),
                        ),
                      ],
                    )),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(height: 0),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text("Full Name: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 25)),
                          const SizedBox(width: 5),
                          Text(
                            "${currentUserData.firstName} ${currentUserData.lastName}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "You cannot change this setting.",
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Text("Display Name: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 25)),
                          const SizedBox(width: 5),
                          Text(
                            currentUserData.displayName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "You cannot change this setting.",
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (currentUserData.parentEmail != null)
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text("Parent Email: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 25)),
                                const SizedBox(width: 5),
                                Text(
                                  currentUserData.parentEmail,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text("You cannot change this setting."),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      Row(
                        children: const [
                          Text("Dark Mode Enabled? ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 25)),
                          SizedBox(width: 5),
                          // if (currentUserData.darkMode == true)
                          //   Icon(Icons.check_circle_outlined, color: Colors.green, size: 30)
                          // else if (currentUserData.darkMode == false)
                          //   Icon(Icons.unpublished_outlined, color: Colors.red, size: 30)
                          Icon(Icons.check_box_outline_blank,
                              color: Colors.black, size: 30)
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Determines if the application is in dark mode.",
                        ),
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Colors.black, width: 0.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              child: Row(
                                children: const [
                                  Icon(Icons.save,
                                      color: Colors.black, size: 20),
                                  SizedBox(width: 5),
                                  Text(
                                    "Save Settings",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => SettingsView(
                                              currentUserData: currentUserData,
                                            )));
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ));
  }
}
