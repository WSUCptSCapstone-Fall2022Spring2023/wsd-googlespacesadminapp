import 'package:flutter/material.dart';
import 'package:spaces_application/presentation/views/loginView.dart';

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
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () => {},
              // onTap: () {
              //   Navigator.pop(context);
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => HomePageView()));
              // }
            ),
            ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title:
                    Text('View Profile', style: TextStyle(color: Colors.white)),
                onTap: () => {Navigator.of(context).pop()}
                // onTap: () {
                //   Navigator.pop(context),
                //   Navigator.push(context,
                //     MaterialPageRoute(builder: ((context) => ProfilePageView()))
                // }
                ),
            ListTile(
                leading: Icon(Icons.school, color: Colors.white),
                title: Text('Classes', style: TextStyle(color: Colors.white)),
                onTap: () => {Navigator.of(context).pop()}
                // onTap: () {
                //   Navigator.pop(context),
                //   Navigator.push(context,
                //     MaterialPageRoute(builder: ((context) => ClassesPageView()))
                // }
                ),
            ListTile(
                leading: Icon(Icons.add_alert, color: Colors.white),
                title: Text('Notifications',
                    style: TextStyle(color: Colors.white)),
                onTap: () => {Navigator.of(context).pop()}
                // onTap: () {
                //   Navigator.pop(context),
                //   Navigator.push(context,
                //     MaterialPageRoute(builder: ((context) => NotificationsPageView()))
                // }
                ),
            ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text('Settings', style: TextStyle(color: Colors.white)),
                onTap: () => {Navigator.of(context).pop()}
                // onTap: () {
                //   Navigator.pop(context),
                //   Navigator.push(context,
                //     MaterialPageRoute(builder: ((context) => SettingsPageView()))
                // }
                ),
            ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text('Logout', style: TextStyle(color: Colors.white)),
                // onTap: () => {Navigator.of(context).pop()},
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => LoginView())));
                }),
          ],
        ));
  }
}
