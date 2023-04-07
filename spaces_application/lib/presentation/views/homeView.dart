import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/presentation/views/settingsView.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:spaces_application/presentation/widgets/navigation_drawer.dart';
import 'package:spaces_application/presentation/widgets/settingsDrawer.dart';

import '../../data/models/userData.dart';
import '../../data/repositories/userData_repository.dart';

import 'package:path/path.dart';

class HomeView extends StatelessWidget {
  HomeView({required this.currentUserData});
  final UserData currentUserData;
  final Color bgColor = Color.fromARGB(255, 49, 49, 49);
  final Color textColor = Color.fromARGB(255, 255, 255, 240);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);

  @override
  Widget build(BuildContext context) {
    //UserData currentUser = g(context) as UserData;
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: MyNavigationDrawer(
          currentUserData: currentUserData,
        ),
        //endDrawer: SettingsDrawer(currentUserData: currentUserData),
        appBar: AppBar(
          elevation: 15,
          // title: Text(currentSpace.spaceName,
          title: const Text("Home Page", style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white, size: 30),
          backgroundColor: bgColor,
        ),
        body: Center(
            child: EasyWebView(
          src: 'https://flutter.dev',
          isMarkdown: false,
          convertToWidgets: false,
        )));
  }

  // Future<UserData> g(context) async {
  //   UserData currentUser =
  //       await context.read<UserDataRepository>().getCurrentUser();
  //   final List<SpaceData> spacesJoined = currentUser.spacesJoined;
  //   return currentUser;
  // }
}
