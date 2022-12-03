import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/presentation/views/create_spaceView.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/views/registerView.dart';

final Color bgColor = Color(0xFF4A4A57);

class NavigationDrawer extends StatelessWidget {
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
              leading: Icon(Icons.home, color: Colors.white),
              title: Text('Home', style: TextStyle(color: Colors.white)),
              //onTap: () => {Navigator.of(context).pop()},
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
              }),
          if (currentUser.isFaculty == true)
            ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text('Create a Student Profile',
                    style: TextStyle(color: Colors.white)),
                // onTap: () => {Navigator.of(context).pop()}
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => RegisterView(),
                  ));
                }),
          if (currentUser.isFaculty == true)
            ListTile(
                leading: Icon(Icons.space_dashboard, color: Colors.white),
                title: Text('Create a New Space',
                    style: TextStyle(color: Colors.white)),
                // onTap: () => {Navigator.of(context).pop()}
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CreateSpaceView(),
                  ));
                }),
          ListTile(
              leading: Icon(Icons.school, color: Colors.white),
              title: Text('Classes', style: TextStyle(color: Colors.white)),
              // onTap: () => {Navigator.of(context).pop()}
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
              }),
          ListTile(
              leading: Icon(Icons.add_alert, color: Colors.white),
              title:
                  Text('Notifications', style: TextStyle(color: Colors.white)),
              // onTap: () => {Navigator.of(context).pop()}
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
              }),
          ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text('Settings', style: TextStyle(color: Colors.white)),
              // onTap: () => {Navigator.of(context).pop()}
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
              }),
          //
          ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              title: Text('Logout', style: TextStyle(color: Colors.white)),
              // onTap: () => {Navigator.of(context).pop()},
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginView(),
                ));
              }),
        ]));
  }
}
