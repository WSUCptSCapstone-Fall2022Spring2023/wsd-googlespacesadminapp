import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';
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
import '../../business_logic/space/space_bloc.dart';
import '../../business_logic/space/space_state.dart';
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
    final Size screenSize = MediaQuery.of(context).size;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double userProfilePicConstraints = screenSize.width <= 500 ? 22 : 30;
    return BlocConsumer<SpaceBloc, SpaceState>(
      listener: (context, state) {
        final dataStatus = state.deleteSpaceStatus;
        if (dataStatus is RetrievalSuccess) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: ((context) => HomeView(
                    currentUserData: state.currentUser,
                  ))));
        } else if (dataStatus is RetrievalFailed) {
          MiscWidgets.showException(context, dataStatus.exception.toString());
        }
      },
      builder: (context, state) {
        return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
            backgroundColor: Colors.white,
            child: Stack(alignment: Alignment.topLeft, children: [
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close,
                              color: Colors.black, size: textSize * 1.2),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )),
                    Text("Delete Space?",
                        style: TextStyle(fontSize: textSize * 2)),
                    SizedBox(height: 10),
                    Text(
                        "This will permanently delete your space, and users will lose access to all content within it.",
                        style: TextStyle(fontSize: textSize * 1.7)),
                    SizedBox(height: 10),
                    Text("Make sure you want to delete this space.",
                        style: TextStyle(fontSize: textSize * 1.7)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          side:
                              const BorderSide(color: Colors.black, width: 0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Text(
                        "Delete Space",
                        style:
                            TextStyle(color: Colors.white, fontSize: textSize),
                      ),
                      onPressed: () {
                        // delete space here
                        context.read<SpaceBloc>().add(DeleteSpace());
                      },
                    )
                  ]))
            ]));
      },
    );
  }
}
