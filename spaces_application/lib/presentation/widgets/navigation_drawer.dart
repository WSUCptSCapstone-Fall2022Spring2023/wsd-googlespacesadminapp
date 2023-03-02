import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/presentation/widgets/createSpaceBottomSheet.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/helpBottomSheet.dart';
import 'package:spaces_application/presentation/widgets/createStudentBottomSheet.dart';
import 'package:spaces_application/presentation/views/profileView.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../../data/repositories/userData_repository.dart';
import '../views/edit_profileView.dart';
import '../views/spaceView.dart';
import 'dart:math';

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({required this.currentUserData});
  final UserData currentUserData;
  final Color navyBlue = Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = Color.fromARGB(255, 45, 40, 138);
  final Color majorelleBlue = Color.fromARGB(255, 86, 85, 221);
  final Color salmon = Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = Color.fromARGB(255, 22, 12, 113);
  final Color lightPink = Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = Color.fromARGB(255, 255, 255, 240);

  @override
  Widget build(BuildContext context) {
    final List spacesJoined = currentUserData.spacesJoined;
    return Drawer(
        child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: <Widget>[
          CircleAvatar(
            radius: 60,
            backgroundColor: offWhite,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  120,
                ),
              ),
              child: SvgPicture.string(
                FluttermojiFunctions().decodeFluttermojifromString(
                    currentUserData.profilePicString),
                height: 120,
                width: 120,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(currentUserData.displayName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(currentUserData.email,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 18)),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(height: 0),
          ),
          // UserAccountsDrawerHeader(
          //   accountName: Text(currentUser.firstName),
          //   accountEmail: Text(currentUser.email),
          //   currentAccountPicture:
          //       Icon(Icons.account_circle, size: 80, color: Colors.white),
          // ),
          ListTile(
              //visualDensity: VisualDensity(vertical: 1),
              leading: const Icon(Icons.home_outlined,
                  color: Colors.black, size: 34),
              title: const Text('Home',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 22)),
              //onTap: () => {Navigator.of(context).pop()},
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeView(
                    currentUserData: currentUserData,
                  ),
                ));
              }),
          ListTile(
            //visualDensity: VisualDensity(vertical: 1),
            leading: const Icon(Icons.account_circle_outlined,
                color: Colors.black, size: 34),
            title: const Text('Profile',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 22)),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => EditProfileView(
                  currentUserData: currentUserData,
                ),
              ));
            },
          ),
          ExpansionTile(
            leading: const Icon(
              Icons.class_outlined,
              color: Colors.black,
              size: 34,
            ),
            title: const Text('Your Spaces',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 22)),
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: spacesJoined.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.space_dashboard_outlined,
                        color: Colors.primaries[
                            Random().nextInt(Colors.primaries.length)]),
                    title: Text('${spacesJoined[index].spaceName}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 18)),
                    onTap: () =>
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => SpaceView(
                                  currentSpace: spacesJoined[index],
                                  currentUserData: currentUserData,
                                ))),
                  );
                },
              ),
            ],
          ),
          if (currentUserData.isFaculty)
            ExpansionTile(
              leading: const Icon(Icons.admin_panel_settings_outlined,
                  color: Colors.black, size: 34),
              title: const Text('Admin',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 22)),
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.person_outline_outlined,
                        color: Colors.black),
                    title: const Text('Create Student Profile',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 18)),
                    onTap: () {
                      // showDialog(
                      //   context: context,
                      //   builder: (context) => RegisterView(),
                      // );
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return CreateStudentBottomSheet();
                          });
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //   builder: (context) => RegisterView(),
                      // ));
                    }),
                ListTile(
                    leading: const Icon(Icons.space_dashboard_outlined,
                        color: Colors.black),
                    title: const Text('Create a New Space',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 18)),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return CreateSpaceBottomSheet();
                          });
                    }),
              ],
            ),
          // ListTile(
          //     leading:
          //         const Icon(Icons.notifications_outlined, color: Colors.black),
          //     title: const Text('Notifications',
          //         style: TextStyle(
          //             color: Colors.black, fontWeight: FontWeight.normal)),
          //     // onTap: () => {Navigator.of(context).pop()}
          //     onTap: () {
          //       Navigator.of(context).pushReplacement(MaterialPageRoute(
          //         builder: (context) => HomeView(),
          //       ));
          //     }),
          ListTile(
              leading:
                  const Icon(Icons.help_outline, color: Colors.black, size: 34),
              title: const Text('Help',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 22)),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return HelpBottomSheet();
                    });
              }),
        ]));
  }

  void reset() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
