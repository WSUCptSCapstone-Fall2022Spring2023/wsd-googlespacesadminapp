import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:spaces_application/presentation/views/settingsView.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:spaces_application/presentation/widgets/navigation_drawer.dart';
import 'package:spaces_application/presentation/widgets/settingsDrawer.dart';
import '../../data/models/userData.dart';
import '../../data/repositories/userData_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:path/path.dart';

class HomeView extends StatefulWidget {
  HomeView({required this.currentUserData});
  final UserData currentUserData;

  @override
  State<HomeView> createState() => _HomeState();
}

class _HomeState extends State<HomeView> {
  final Color bgColor = Color.fromARGB(255, 49, 49, 49);
  final Color textColor = Color.fromARGB(255, 255, 255, 240);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: PointerInterceptor(
        child: MyNavigationDrawer(
          currentUserData: widget.currentUserData,
        ),
      ),
      onDrawerChanged: (isOpened) {
        setState(() {
          isDrawerOpen = !isDrawerOpen;
        });
      },
      //endDrawer: SettingsDrawer(currentUserData: currentUserData),
      appBar: AppBar(
        elevation: 15,
        // title: Text(currentSpace.spaceName,
        title: const Text("Home Page", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        backgroundColor: bgColor,
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: "https://wahksd.k12.wa.us/",
          ),
          PointerInterceptor(
            intercepting: isDrawerOpen,
            child: SizedBox(
              height: ScreenHeight,
              width: ScreenWidth,
            ),
          )
        ],
      ),
    );
  }

  // Future<UserData> g(context) async {
  //   UserData currentUser =
  //       await context.read<UserDataRepository>().getCurrentUser();
  //   final List<SpaceData> spacesJoined = currentUser.spacesJoined;
  //   return currentUser;
  // }
}
