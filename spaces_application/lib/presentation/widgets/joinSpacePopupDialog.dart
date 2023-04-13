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
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
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
        return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Dialog(
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 150, vertical: 250),
                backgroundColor: Colors.white,
                child: Stack(alignment: Alignment.topLeft, children: [
                  Container(
                      width: double.infinity,
                      height: ScreenHeight * 0.4,
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
                        Text("Join Space?", style: TextStyle(fontSize: 50)),
                        SizedBox(height: 10),
                        Text(
                            "Are you sure you want to join the following space:",
                            style: TextStyle(fontSize: 35)),
                        SizedBox(height: 10),
                        Text("${selectedSpace.spaceName}",
                            style: TextStyle(fontSize: 35)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              side: const BorderSide(
                                  color: Colors.black, width: 0.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: const Text(
                            "Join Space",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            // join space here
                            context
                                .read<NavBarBloc>()
                                .add(JoinSpace(selectedSpace: selectedSpace));
                          },
                        )
                      ]))
                ])));
      },
    );
  }
}
