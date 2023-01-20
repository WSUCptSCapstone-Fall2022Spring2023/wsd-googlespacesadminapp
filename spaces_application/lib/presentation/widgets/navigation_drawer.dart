import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/presentation/views/create_spaceView.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/views/registerView.dart';

import '../../data/repositories/userData_repository.dart';

class NavigationDrawer extends StatelessWidget {
  final Color bgColor = Color.fromARGB(255, 49, 49, 49);
  final Color textColor = Color.fromARGB(255, 255, 255, 240);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);

  @override
  Widget build(BuildContext context) {
    UserData currentUser =
        context.read<UserDataRepository>().currentUserData as UserData;
    final List spacesPermissions = currentUser.spacesPermissions;
    return Drawer(
        backgroundColor: bgColor,
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(currentUser.firstName),
            accountEmail: Text(currentUser.email),
            currentAccountPicture:
                Icon(Icons.account_circle, size: 80, color: Colors.white),
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage('assets/nav_drawer_background.jfif'),
            //         fit: BoxFit.cover)),
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
          if (currentUser.isFaculty)
            ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text('Create Student Profile',
                    style: TextStyle(color: Colors.white)),
                // onTap: () => {Navigator.of(context).pop()}
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => RegisterView(),
                  );
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //   builder: (context) => RegisterView(),
                  // ));
                }),
          if (currentUser.isFaculty)
            ListTile(
                leading: Icon(Icons.space_dashboard, color: Colors.white),
                title: Text('Create a new Space',
                    style: TextStyle(color: Colors.white)),
                // onTap: () => {Navigator.of(context).pop()}
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => CreateSpaceView(),
                  );
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //   builder: (context) => RegisterView(),
                  // ));
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
          Container(
              height: 1000,
              width: 1000,
              child: ListView.builder(
                  //shrinkWrap: true,
                  itemCount: spacesPermissions.length,
                  itemBuilder: (context, index) {
                    return Container(
                        child: ListTile(
                            title:
                                Text('${spacesPermissions[index].spaceID}')));
                  }))
        ]));
  }
}
