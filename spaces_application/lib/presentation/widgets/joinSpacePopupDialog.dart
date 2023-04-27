import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';
import 'package:spaces_application/business_logic/nav_bar/nav_bloc.dart';
import 'package:spaces_application/business_logic/nav_bar/nav_state.dart';
import 'package:spaces_application/business_logic/space/space_event.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/presentation/widgets/createSpacePopUpDialog.dart';
import 'package:spaces_application/presentation/views/loginView.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/helpPopUpDialog.dart';
import 'package:spaces_application/presentation/widgets/createStudentPopUpDialog.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../../business_logic/nav_bar/nav_event.dart';
import '../../business_logic/space/space_bloc.dart';
import '../../business_logic/space/space_state.dart';
import '../../data/models/spaceData.dart';
import '../../data/repositories/userData_repository.dart';
import '../views/edit_profileView.dart';
import '../views/spaceView.dart';
import 'dart:math';

import 'package:path/path.dart';

class joinSpaceDialog extends StatelessWidget {
  joinSpaceDialog({required this.selectedSpace, required this.currentUserData});
  final SpaceData selectedSpace;
  final UserData currentUserData;

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color darkViolet = const Color.fromARGB(255, 9, 5, 5);
  final Color navyBlue = const Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = const Color.fromARGB(255, 45, 40, 208);
  final Color majorelleBlue = const Color.fromARGB(255, 86, 85, 221);
  final Color salmon = const Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = const Color.fromARGB(255, 22, 12, 120);
  final Color lightPink = const Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = const Color.fromARGB(255, 255, 255, 240);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double imageWidth = screenSize.width * 0.7;
    final double imageHeight = screenSize.height * 0.4;
    final double textScaleFactor = screenSize.width < 700 ? 3 : 5;
    final double textSize = screenSize.width < 700 ? 12 : 20;

    return BlocConsumer<NavBarBloc, NavBarState>(
      listener: (context, state) {
        final dataStatus = state.joinSpaceStatus;
        if (dataStatus is SubmissionSuccess) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: ((context) => SpaceView(
                    currentSpace: selectedSpace,
                    currentUserData: state.currentUserData,
                  ))));
        } else if (dataStatus is SubmissionFailed) {
          MiscWidgets.showException(context, dataStatus.exception.toString());
        }
      },
      builder: (context, state) {
        return Dialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: 50, vertical: screenSize.width < 700 ? 310 : 275),
            backgroundColor: Colors.white,
            child: Stack(alignment: Alignment.topLeft, children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close,
                              color: Colors.black, size: textSize * 1.25),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Join Space?",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: textSize * 1.7))),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: textSize),
                        child: const Divider(height: 0)),
                    Text("Are you sure you want to join this space?",
                        style: TextStyle(fontSize: textSize)),
                    Text("Space Name: ${selectedSpace.spaceName}",
                        style: TextStyle(fontSize: textSize)),
                    Text("Space Description: ${selectedSpace.spaceDescription}",
                        style: TextStyle(fontSize: textSize)),
                    SizedBox(
                      height: textSize,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            side: const BorderSide(
                                color: Colors.white, width: 0.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: Text('Join Space',
                            style: TextStyle(
                                color: Colors.white, fontSize: textSize * 0.8)),
                        onPressed: () {
                          context
                              .read<NavBarBloc>()
                              .add(JoinSpace(selectedSpace: selectedSpace));
                        },
                      ),
                    ),
                  ]))
            ]));
      },
    );
  }
}
