import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';
import '../../business_logic/create_space/create_space_bloc.dart';
import '../../business_logic/create_space/create_space_event.dart';
import '../../business_logic/create_space/create_space_state.dart';
import '../../data/repositories/space_repository.dart';
import '../../data/repositories/userData_repository.dart';

class HelpBottomSheet extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color bgColor = Color.fromARGB(255, 12, 12, 12);
  final Color textColor = Color.fromARGB(255, 255, 255, 240);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Help",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Divider(height: 0),
                  ),
                  ListTile(
                      title: const Text("Clear Your Browser Cache",
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
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Divider(height: 0),
                  ),
                  ListTile(
                      title: const Text("See our Slate guide."),
                      onTap: () {
                        MiscWidgets.showException(context, "Go to pdf doc.");
                      }),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
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
  }
}
