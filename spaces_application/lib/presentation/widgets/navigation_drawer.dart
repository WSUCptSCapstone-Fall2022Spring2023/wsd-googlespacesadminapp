import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';
import 'package:spaces_application/business_logic/nav_bar/nav_bloc.dart';
import 'package:spaces_application/business_logic/nav_bar/nav_event.dart';
import 'package:spaces_application/business_logic/nav_bar/nav_state.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/data/repositories/space_repository.dart';
import 'package:spaces_application/presentation/views/profileView.dart';
import 'package:spaces_application/presentation/views/settingsView.dart';
import 'package:spaces_application/presentation/widgets/createSpacePopUpDialog.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/helpPopUpDialog.dart';
import 'package:spaces_application/presentation/widgets/createStudentPopUpDialog.dart';
import 'package:spaces_application/presentation/widgets/joinSpacePopupDialog.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../../data/repositories/userData_repository.dart';
import '../views/edit_profileView.dart';
import '../views/spaceView.dart';
import 'dart:math';

class MyNavigationDrawer extends StatelessWidget {
  MyNavigationDrawer({required this.currentUserData});
  final UserData currentUserData;

  final Color bgColor = const Color.fromARGB(255, 49, 49, 49);

  @override
  Widget build(BuildContext context) {
    final List spacesJoined = currentUserData.spacesJoined;

    final Size screenSize = MediaQuery.of(context).size;
    final double imageWidth = screenSize.width * 0.7;
    final double imageHeight = screenSize.height * 0.4;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double postBoxConstraints = screenSize.width <= 500 ? 30 : 50;
    final double commentBoxConstraints = screenSize.width <= 500 ? 20 : 30;
    return BlocProvider(
      create: (context) => NavBarBloc(
          spaceRepo: context.read<SpaceRepository>(),
          userRepo: context.read<UserDataRepository>(),
          currentUserData: currentUserData),
      child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 50),
              children: <Widget>[
                CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey[200],
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        150,
                      ),
                    ),
                    child: SvgPicture.string(
                      FluttermojiFunctions().decodeFluttermojifromString(
                          currentUserData.profilePicString),
                      height: 150,
                      width: 150,
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
                const SizedBox(height: 10),
                ListTile(
                    //visualDensity: VisualDensity(vertical: 1),
                    leading: Icon(Icons.home, color: bgColor, size: 34),
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
                const SizedBox(height: 10),
                ListTile(
                  //visualDensity: VisualDensity(vertical: 1),
                  leading: Icon(Icons.account_circle, color: bgColor, size: 34),
                  title: const Text('Profile',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 22)),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ProfileView(
                        currentUserData: currentUserData,
                      ),
                    ));
                  },
                ),
                const SizedBox(height: 10),
                ExpansionTile(
                  leading: Icon(
                    Icons.class_,
                    color: bgColor,
                    size: 34,
                  ),
                  title: const Text('Your Spaces',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 22)),
                  children: <Widget>[
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: spacesJoined.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.space_dashboard,
                              color: Colors.primaries[
                                  Random().nextInt(Colors.primaries.length)]),
                          title: Text('${spacesJoined[index].spaceName}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18)),
                          onTap: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => SpaceView(
                                        currentSpace: spacesJoined[index],
                                        currentUserData: currentUserData,
                                      ))),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ExpansionTile(
                  leading: Icon(
                    Icons.class_outlined,
                    color: bgColor,
                    size: 34,
                  ),
                  title: currentUserData.isFaculty
                      ? const Text('All Spaces',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 22))
                      : const Text('Public Spaces',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 22)),
                  children: [
                    BlocBuilder<NavBarBloc, NavBarState>(
                      builder: (context, state) {
                        if (state.spaceRetrievalStatus
                            is InitialRetrievalStatus) {
                          context.read<NavBarBloc>().add(GetUnjoinedSpaces());
                          return const SizedBox.shrink();
                        } else if (state.spaceRetrievalStatus
                            is DataRetrieving) {
                          return const CircularProgressIndicator();
                        } else if (state.spaceRetrievalStatus
                            is RetrievalSuccess) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.publicSpaces.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  leading: Icon(Icons.space_dashboard,
                                      color: Colors.primaries[Random()
                                          .nextInt(Colors.primaries.length)]),
                                  title: Text(
                                      '${state.publicSpaces[index].spaceName}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18)),
                                  onTap: () => showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (_) {
                                          return BlocProvider.value(
                                            value: BlocProvider.of<NavBarBloc>(
                                                context),
                                            child: joinSpaceDialog(
                                                currentUserData:
                                                    currentUserData,
                                                selectedSpace:
                                                    state.publicSpaces[index]),
                                          );
                                        },
                                      ));
                            },
                          );
                        } else {
                          return const Text(
                              "Data could not be retrieved. Please try again");
                        }
                      },
                    ),
                  ],
                ),
                if (currentUserData.isFaculty) const SizedBox(height: 10),
                if (currentUserData.isFaculty)
                  ExpansionTile(
                    leading: Icon(Icons.admin_panel_settings,
                        color: bgColor, size: 34),
                    title: const Text('Admin',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 22)),
                    children: <Widget>[
                      const SizedBox(height: 10),
                      ListTile(
                          leading: Icon(Icons.person_outline, color: bgColor),
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
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return CreateStudentPopUpDialog();
                                });
                            // Navigator.of(context).pushReplacement(MaterialPageRoute(
                            //   builder: (context) => RegisterView(),
                            // ));
                          }),
                      const SizedBox(height: 10),
                      ListTile(
                          leading: Icon(Icons.space_dashboard, color: bgColor),
                          title: const Text('Create a New Space',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18)),
                          onTap: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return CreateSpacePopUpDialog();
                                });
                          }),
                    ],
                  ),
                const SizedBox(height: 10),
                ListTile(
                    leading: Icon(Icons.help_outline, color: bgColor, size: 34),
                    title: const Text('Help',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 22)),
                    onTap: () {
                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return HelpPopUpDialog();
                          });
                    }),
                const SizedBox(height: 10),
                ListTile(
                    leading: Icon(Icons.settings, color: bgColor, size: 34),
                    title: const Text('Settings',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 22)),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) =>
                              SettingsView(currentUserData: currentUserData))));
                    }),
                const SizedBox(height: 10),
                ListTile(
                    leading: Icon(Icons.logout, color: bgColor, size: 34),
                    title: const Text('Logout',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 22)),
                    // onTap: () => {Navigator.of(context).pop()}
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => LoginView(),
                      ));
                    }),
              ])),
    );
  }

  void reset() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
