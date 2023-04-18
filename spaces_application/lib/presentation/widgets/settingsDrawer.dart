import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/presentation/widgets/createInviteUserPopupDialog.dart';
import 'package:spaces_application/presentation/widgets/createUserProfileViewDialog.dart';
import 'package:spaces_application/presentation/widgets/deleteSpacePopupDialog.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:spaces_application/presentation/widgets/viewProfileDialog.dart';
import '../../business_logic/space/space_bloc.dart';
import '../../business_logic/space/space_event.dart';
import '../../data/models/spaceData.dart';
import '../../business_logic/space/space_state.dart';

import '../../data/repositories/userData_repository.dart';
import '../views/edit_profileView.dart';
import '../views/spaceView.dart';
import 'dart:math';

import 'package:path/path.dart';

class SettingsDrawer extends StatefulWidget {
  SettingsDrawer({required this.currentUserData, this.currentSpace});
  SpaceData? currentSpace;
  final UserData currentUserData;

  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final Color navyBlue = const Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = const Color.fromARGB(255, 45, 40, 138);
  final Color majorelleBlue = const Color.fromARGB(255, 86, 85, 221);
  final Color salmon = const Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = const Color.fromARGB(255, 22, 12, 113);
  final Color lightPink = const Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = Color.fromARGB(220, 255, 255, 255);

  final Color bgColor = Color.fromARGB(255, 49, 49, 49);

  @override
  Widget build(BuildContext context) {
    final List spacesJoined = widget.currentUserData.spacesJoined;
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    List<UserData> userList = List<UserData>.empty(growable: true);
    bool isPrivate = widget.currentSpace!.isPrivate;

    final Size screenSize = MediaQuery.of(context).size;
    final double imageWidth = screenSize.width * 0.7;
    final double imageHeight = screenSize.height * 0.4;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = 12;
    final double postBoxConstraints = screenSize.width <= 500 ? 30 : 50;
    final double commentBoxConstraints = screenSize.width <= 500 ? 20 : 30;
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Space Menu",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: textSize * 2.2)),
            const SizedBox(height: 15),
            // if (currentSpace.isPrivate)
            // if (currentSpace_isPrivate)
            // ListTile(
            //     leading: const Icon(Icons.lock_open_outlined,
            //         color: Colors.black, size: 34),
            //     title: const Text("Make Space not private.",
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontWeight: FontWeight.normal,
            //             fontSize: 22)),
            //     onTap: () {
            //       // currentSpace.isPrivate = false;
            //       currentSpace_isPrivate = true;
            //     }),
            // if (!currentSpace.isPrivate)
            // if (!currentSpace_isPrivate)
            ListTile(
              leading:
                  Icon(Icons.lock, color: Colors.black, size: textSize * 2),
              title: Text("Private",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: textSize * 1.8)),
              trailing: Switch(
                value: widget.currentSpace!.isPrivate,
                onChanged: (value) {
                  context.read<SpaceBloc>().add(ChangePrivacy());
                  setState(() {
                    isPrivate = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle,
                  color: bgColor, size: textSize * 2),
              title: Text("Invite User",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: textSize * 1.8)),
              onTap: () {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (_) {
                    return BlocProvider.value(
                      value: BlocProvider.of<SpaceBloc>(context),
                      child: CreateInviteUserPopUpDialog(),
                    );
                  },
                );
              },
            ),
            ExpansionTile(
              leading:
                  Icon(Icons.person_search, color: bgColor, size: textSize * 2),
              title: Text('Space Users',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: textSize * 1.8)),
              children: [
                BlocBuilder<SpaceBloc, SpaceState>(
                  builder: (context, state) {
                    if (state.getUsersStatus is InitialRetrievalStatus) {
                      context.read<SpaceBloc>().add(GetSpaceUsers());
                      return const SizedBox.shrink();
                    } else if (state.getUsersStatus is DataRetrieving) {
                      return SizedBox(
                          width: textSize * 5,
                          height: textSize * 5,
                          child:
                              const Center(child: CircularProgressIndicator()));
                    } else if (state.getUsersStatus is RetrievalSuccess) {
                      userList = state.spaceUsers;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: userList.length,
                          itemBuilder: ((context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: textSize * 1.4,
                                backgroundColor: Colors.grey[200],
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                      150,
                                    ),
                                  ),
                                  child: SvgPicture.string(
                                    FluttermojiFunctions()
                                        .decodeFluttermojifromString(
                                            userList[index].profilePicString),
                                    height: 150,
                                    width: 150,
                                  ),
                                ),
                              ),
                              title: Text(userList[index].displayName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: textSize * 1.4)),
                              onTap: () {
                                showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: ((_) {
                                      return BlocProvider.value(
                                        value:
                                            BlocProvider.of<SpaceBloc>(context),
                                        child: ViewProfileDialog(
                                            selectedUserData: userList[index]),
                                      );
                                    }));
                              },
                            );
                          }));
                    } else if (state.getUsersStatus is RetrievalFailed) {
                      return const Center(
                          child: Text(
                              "Error with Data Retrieval. Please Refresh."));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                )
              ],
            ),
            if (widget.currentUserData.isFaculty)
              ListTile(
                leading: Icon(Icons.delete_forever,
                    color: bgColor, size: textSize * 2),
                title: Text("Delete Space",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: textSize * 1.8)),
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      barrierColor: Colors.red,
                      context: context,
                      builder: ((_) {
                        return BlocProvider.value(
                          value: BlocProvider.of<SpaceBloc>(context),
                          child: DeleteSpacePopupDialog(
                              currentSpace: widget.currentSpace,
                              currentUserData: widget.currentUserData),
                        );
                      }));
                },
              ),
          ],
        ),
      ),
    );
  }
}
