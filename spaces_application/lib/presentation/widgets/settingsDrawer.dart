import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/presentation/widgets/createSpacePopUpDialog.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/createUserProfileViewDialog.dart';
import 'package:spaces_application/presentation/widgets/deleteSpacePopupDialog.dart';
import 'package:spaces_application/presentation/widgets/helpPopUpDialog.dart';
import 'package:spaces_application/presentation/widgets/createStudentPopUpDialog.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../../business_logic/space/space_bloc.dart';
import '../../business_logic/space/space_event.dart';
import '../../data/models/spaceData.dart';
import '../../business_logic/space/space_state.dart';

import '../../data/repositories/userData_repository.dart';
import '../views/edit_profileView.dart';
import '../views/spaceView.dart';
import 'dart:math';

import 'package:path/path.dart';

class SettingsDrawer extends StatelessWidget {
  SettingsDrawer({required this.currentUserData, this.currentSpace});
  SpaceData? currentSpace;
  final UserData currentUserData;
  bool currentSpace_isPrivate = false;

  final Color navyBlue = const Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = const Color.fromARGB(255, 45, 40, 138);
  final Color majorelleBlue = const Color.fromARGB(255, 86, 85, 221);
  final Color salmon = const Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = const Color.fromARGB(255, 22, 12, 113);
  final Color lightPink = const Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = const Color.fromARGB(255, 255, 255, 240);

  @override
  Widget build(BuildContext context) {
    context.read<SpaceBloc>().add(GetUsers());

    List<UserData> userList = state.users;

    final List spacesJoined = currentUserData.spacesJoined;
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      // width: ScreenWidth / 4,
      // height: ScreenHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Space Menu",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 28)),
            const SizedBox(height: 15),
            // if (currentSpace.isPrivate)
            // if (currentSpace_isPrivate)
            // ListTile(
            //     leading: const Icon(Icons.lock_open_outlined,
            //         color: Colors.black, size: 34),
            //     title: const Text("Make Space not private.",
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontWeight: FontWeight.normal,
            //             fontSize: 22)),
            //     onTap: () {
            //       // currentSpace.isPrivate = false;
            //       currentSpace_isPrivate = true;
            //     }),
            // if (!currentSpace.isPrivate)
            // if (!currentSpace_isPrivate)
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.black, size: 25),
              title: const Text("Space Privacy",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 20)),
              onTap: () {
                // currentSpace.isPrivate = true;
                // currentSpace_isPrivate = false;
              },
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle,
                  color: Colors.black, size: 25),
              title: const Text("Invite User",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 20)),
              onTap: () {},
            ),
            ExpansionTile(
              leading: const Icon(Icons.person_search,
                  color: Colors.black, size: 34),
              title: const Text('Space Users',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 20)),
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: userList.length,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey[200],
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                150,
                              ),
                            ),
                            child: SvgPicture.string(
                              FluttermojiFunctions()
                                  .decodeFluttermojifromString(
                                      userList[index].profilePicString),
                              height: 150,
                              width: 150,
                            ),
                          ),
                        ),
                        title: Text(userList[index].displayName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 10)),
                        onTap: () {
                          showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: ((context) {
                                return CreateUserProfileViewDialog(
                                    currentSpace: currentSpace,
                                    currentUserData: currentUserData,
                                    // selectedUser: currentSpace?.membersPermissions[index],
                                    selectedUserData: userList[index]);
                              }));
                        },
                      );
                    }))
              ],
            ),
            const SizedBox(height: 10),
            if (currentUserData.isFaculty)
              ListTile(
                leading: const Icon(Icons.delete_forever,
                    color: Colors.black, size: 25),
                title: const Text("Delete Space",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 20)),
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      barrierColor: Colors.red,
                      context: context,
                      builder: ((context) {
                        return DeleteSpacePopupDialog(
                            currentSpace: currentSpace,
                            currentUserData: currentUserData);
                      }));
                },
              ),
          ],
        ),
      ),
    );
  }
}
