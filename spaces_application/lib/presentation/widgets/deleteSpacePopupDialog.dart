import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/presentation/widgets/createSpacePopUpDialog.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/helpPopUpDialog.dart';
import 'package:spaces_application/presentation/widgets/createStudentPopUpDialog.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/spaceData.dart';
import '../../data/repositories/userData_repository.dart';
import '../views/edit_profileView.dart';
import '../views/spaceView.dart';
import 'dart:math';

import 'package:path/path.dart';

class DeleteSpacePopupDialog extends StatelessWidget {
  DeleteSpacePopupDialog(
      {required this.currentSpace, required this.currentUserData});
  SpaceData? currentSpace;
  final UserData currentUserData;

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color darkViolet = Color.fromARGB(255, 9, 5, 5);
  final Color navyBlue = Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = Color.fromARGB(255, 45, 40, 208);
  final Color majorelleBlue = Color.fromARGB(255, 86, 85, 221);
  final Color salmon = Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = Color.fromARGB(255, 22, 12, 120);
  final Color lightPink = Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = Color.fromARGB(255, 255, 255, 240);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 150, vertical: 250),
            backgroundColor: Colors.white,
            child: Stack(alignment: Alignment.topLeft, children: [
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.black, size: 25),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )),
                    Text("Delte Space?", style: TextStyle(fontSize: 50)),
                    SizedBox(height: 10),
                    Text(
                        "This will permanently delete your space, and users will lose access to all content within it.",
                        style: TextStyle(fontSize: 35)),
                    SizedBox(height: 10),
                    Text("Be sure you mean to delete this space.",
                        style: TextStyle(fontSize: 35)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          side:
                              const BorderSide(color: Colors.black, width: 0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: const Text(
                        "Delete Space",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        // delete space here
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: ((context) => HomeView(
                                  currentUserData: currentUserData,
                                ))));
                      },
                    )
                  ]))
            ])));
  }
}