import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/presentation/views/create_spaceView.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/views/registerView.dart';

class NavigationDrawer extends StatelessWidget {
  final Color bgColor = Color.fromARGB(255, 12, 12, 12);
  final Color textColor = Color.fromARGB(255, 255, 255, 240);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);

  @override
  Widget build(BuildContext context) {
    UserData currentUser =
        context.read<AuthRepository>().currentUser as UserData;
    bool condition = false;
    return Drawer(
        backgroundColor: bgColor,
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(currentUser.firstName),
            accountEmail: Text(currentUser.email),
            currentAccountPicture: Icon(Icons.account_circle, size: 80),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets\images\exampleprofilebackgroundpicture.jpg"))),
          ),
          ListTile(
              leading: Icon(Icons.home, color: textColor),
              title: Text('Home', style: TextStyle(color: textColor)),
              //onTap: () => {Navigator.of(context).pop()},
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
              }),
          if (currentUser.isFaculty == true)
            ListTile(
                leading: Icon(Icons.person, color: textColor),
                title: Text('Create a Student Profile',
                    style: TextStyle(color: textColor)),
                // onTap: () => {Navigator.of(context).pop()}
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => RegisterView(),
                  ));
                  // showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return RegisterView();
                  //     });
                }),
          if (currentUser.isFaculty == true)
            ListTile(
                leading: Icon(Icons.space_dashboard, color: textColor),
                title: Text('Create a New Space',
                    style: TextStyle(color: textColor)),
                // onTap: () => {Navigator.of(context).pop()}
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CreateSpaceView(),
                  ));
                }),
          ListTile(
              leading: Icon(Icons.school, color: textColor),
              title: Text('Classes', style: TextStyle(color: textColor)),
              // onTap: () => {Navigator.of(context).pop()}
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
              }),
          ListTile(
              leading: Icon(Icons.add_alert, color: textColor),
              title: Text('Notifications', style: TextStyle(color: textColor)),
              // onTap: () => {Navigator.of(context).pop()}
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
              }),
          ListTile(
              leading: Icon(Icons.settings, color: textColor),
              title: Text('Settings', style: TextStyle(color: textColor)),
              // onTap: () => {Navigator.of(context).pop()}
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
              }),
          //
          ListTile(
              leading: Icon(Icons.exit_to_app, color: textColor),
              title: Text('Logout', style: TextStyle(color: textColor)),
              // onTap: () => {Navigator.of(context).pop()},
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginView(),
                ));
              }),
        ]));
  }
}
