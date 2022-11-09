import 'package:flutter/material.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:spaces_application/presentation/views/homePageView.dart';

final Color bgColor = Color(0xFF4A4A57);

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: bgColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('User'),
              accountEmail: Text('user@email.com'),
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
                }),
            ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title:
                    Text('View Profile', style: TextStyle(color: Colors.white)),
                // onTap: () => {Navigator.of(context).pop()}
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
                }),
            ListTile(
                leading: Icon(Icons.school, color: Colors.white),
                title: Text('Classes', style: TextStyle(color: Colors.white)),
                // onTap: () => {Navigator.of(context).pop()}
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
                }),
            ListTile(
                leading: Icon(Icons.add_alert, color: Colors.white),
                title: Text('Notifications',
                    style: TextStyle(color: Colors.white)),
                // onTap: () => {Navigator.of(context).pop()}
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
                }),
            ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text('Settings', style: TextStyle(color: Colors.white)),
                // onTap: () => {Navigator.of(context).pop()}
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
                }),
            //
            ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text('Logout', style: TextStyle(color: Colors.white)),
                // onTap: () => {Navigator.of(context).pop()},
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  // may have to change this if users are automatically logged in.
                }),
          ],
        ));
  }
}
