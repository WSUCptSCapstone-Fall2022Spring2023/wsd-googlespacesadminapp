import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

import '../../business_logic/auth/form_submission_status.dart';
import '../../business_logic/create_space/create_space_bloc.dart';
import '../../business_logic/create_space/create_space_event.dart';
import '../../business_logic/create_space/create_space_state.dart';
import '../../data/repositories/space_repository.dart';
import '../../data/repositories/userData_repository.dart';

final Uri clearCacheUrl =
    Uri.parse('https://its.uiowa.edu/support/article/719');

class HelpPopUpDialog extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color bgColor = const Color.fromARGB(255, 12, 12, 12);
  final Color textColor = const Color.fromARGB(255, 255, 255, 240);
  final Color boxColor = const Color.fromARGB(255, 60, 60, 60);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double postBoxConstraints = screenSize.width <= 500 ? 30 : 50;
    final double commentBoxConstraints = screenSize.width <= 500 ? 20 : 30;
    return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 200),
        child: Stack(alignment: Alignment.center, children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.black, size: 25),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Help",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: textSize * 1.7)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: textSize),
                  child: const Divider(height: 0),
                ),
                ListTile(
                  title: Text("Clear Your Browser Cache",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: textSize)),
                  subtitle: Text(
                      "Many problems can be solved by clearing your browser cache. Click for more information",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: textSize * 0.8)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: const Text("Help"),
                              leading: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            body: Stack(
                              children: const [
                                WebView(
                                  initialUrl: "https://google.com/",
                                ),
                              ],
                            )),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Divider(height: 0),
                ),
                ListTile(
                  title: Text("See our Slate guide.",
                      style: TextStyle(
                        fontSize: textSize,
                      )),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: const Text("Help"),
                            leading: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          body: const WebView(
                            initialUrl: 'https://google.com',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ]));
  }
}
