import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/presentation/views/create_spaceView.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/views/registerView.dart';
import 'package:spaces_application/presentation/views/profileView.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

class NavigationDrawer extends StatelessWidget {
  final Color navyBlue = Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = Color.fromARGB(255, 45, 40, 138);
  final Color majorelleBlue = Color.fromARGB(255, 86, 85, 221);
  final Color salmon = Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = Color.fromARGB(255, 22, 12, 113);
  final Color lightPink = Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = Color.fromARGB(255, 255, 255, 240);

  @override
  Widget build(BuildContext context) {
    UserData currentUser =
        context.read<AuthRepository>().currentUser as UserData;
    final List spacesPermissions = currentUser.spacesPermissions;
    return Drawer(
        child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: <Widget>[
          Icon(Icons.account_circle, size: 150, color: salmon),
          const SizedBox(height: 15),
          Text(currentUser.firstName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(currentUser.email,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black)),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(height: 0),
          ),
          // UserAccountsDrawerHeader(
          //   accountName: Text(currentUser.firstName),
          //   accountEmail: Text(currentUser.email),
          //   currentAccountPicture:
          //       Icon(Icons.account_circle, size: 80, color: Colors.white),
          // ),
          ListTile(
              leading: const Icon(Icons.home_outlined, color: Colors.black),
              title: const Text('Home',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal)),
              //onTap: () => {Navigator.of(context).pop()},
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
              }),
          ListTile(
            leading:
                const Icon(Icons.account_circle_outlined, color: Colors.black),
            title: const Text('Profile',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal)),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => ProfileView(),
              ));
            },
          ),
          if (currentUser.isFaculty)
            ListTile(
                leading: const Icon(Icons.person_outline_outlined,
                    color: Colors.black),
                title: const Text('Create Student Profile',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
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
                leading: const Icon(Icons.space_dashboard_outlined,
                    color: Colors.black),
                title: const Text('Create a new Space',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
                // onTap: () => {Navigator.of(context).pop()}
                // onTap: () {
                //   showDialog(
                //     context: context,
                //     builder: (context) => CreateSpaceView(),
                //   );
                //   // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //   //   builder: (context) => RegisterView(),
                //   // ));
                // }
                onTap: () {}),
          ListTile(
              leading:
                  const Icon(Icons.notifications_outlined, color: Colors.black),
              title: const Text('Notifications',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal)),
              // onTap: () => {Navigator.of(context).pop()}
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
              }),
          ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.black),
              title: const Text('Help',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal)),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Help",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Divider(height: 0),
                                    ),
                                    ListTile(
                                        title: const Text(
                                            "Clear Your Browser Cache",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        subtitle: const Text(
                                            "Many problems can be solved by clearing your browser cache.",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal)),
                                        onTap: () {
                                          MiscWidgets.showException(
                                              context, "Send Admin Message");
                                        }),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Divider(height: 0),
                                    ),
                                    ListTile(
                                        title:
                                            const Text("See our Slate guide."),
                                        onTap: () {
                                          MiscWidgets.showException(
                                              context, "Go to pdf doc.");
                                        }),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Divider(height: 0),
                                    ),
                                    ListTile(
                                        title: const Text(
                                          "Done",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        })
                                  ])));
                    });
              }),
          ListTile(
              leading: const Icon(Icons.settings_outlined, color: Colors.black),
              title: const Text('Settings',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal)),
              // onTap: () => {Navigator.of(context).pop()}
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
              }),
          ListTile(
              leading:
                  const Icon(Icons.exit_to_app_outlined, color: Colors.black),
              title: const Text('Logout',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal)),
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
