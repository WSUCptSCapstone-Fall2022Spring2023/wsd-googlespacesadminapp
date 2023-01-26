import 'package:flutter/material.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:spaces_application/presentation/widgets/navigation_drawer.dart';

class SettingsView extends StatelessWidget {
  final Color bgColor = Color.fromARGB(255, 49, 49, 49);
  final Color textColor = Color.fromARGB(255, 255, 255, 240);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);

  @override
  Widget build(BuildContext context) {
    //UserData currentUser = g(context) as UserData;
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: bgColor,
        drawer: NavigationDrawer(),
        appBar: AppBar(
            elevation: 15, title: Text("Settings"), backgroundColor: bgColor),
        body: ElevatedButton(
            child: const Text("Logout"),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginView()));
            }));
  }

  // Future<UserData> g(context) async {
  //   UserData currentUser =
  //       await context.read<UserDataRepository>().getCurrentUser();
  //   final List<SpaceData> spacesJoined = currentUser.spacesJoined;
  //   return currentUser;
  // }
}
