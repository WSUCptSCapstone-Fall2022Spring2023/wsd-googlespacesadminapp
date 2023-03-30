import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/data/models/permissionData.dart';
import 'package:spaces_application/data/models/spaceData.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/confirmInviteUsersPopUp.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';
import '../../business_logic/create_space/create_space_bloc.dart';
import '../../business_logic/create_space/create_space_event.dart';
import '../../business_logic/create_space/create_space_state.dart';
import '../../data/repositories/space_repository.dart';
import '../../data/repositories/userData_repository.dart';

class CreateInviteUserPopUpDialog extends StatefulWidget {
  // String uid = "";
  // bool isFaculty = false;
  // String email = "";
  // String parentEmail = "";
  // String firstName = "";
  // String lastName = "";
  // String displayName = "";
  // List<PermissionData> spacesPermissions =
  //   List<PermissionData>.empty(growable: true);

  // MyStatefulWidget({required this.uid, required this.isFaculty, required this.email,
  // required this.parentEmail, required this.firstName, required this.lastName, required this.displayName,
  // required this.spacesPermissions});

  CreateInviteUserPopUpDialog(
      {required this.currentUserData, required this.currentSpace});

  final UserData currentUserData;
  final SpaceData? currentSpace;

  @override
  _CreateInviteUserPopUpDialogState createState() =>
      _CreateInviteUserPopUpDialogState();
}

class _CreateInviteUserPopUpDialogState
    extends State<CreateInviteUserPopUpDialog> {
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<int> _selectedUsersIndices = [];
  SpaceData? currentSpace;

  @override
  Widget build(BuildContext context) {
    var ScreenHeight = MediaQuery.of(context).size.height;
    return Dialog(
        // insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
        backgroundColor: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: ScreenHeight * 0.8,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.black, size: 25),
                        onPressed: (() {
                          Navigator.pop(context);
                        })),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Invite a User",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 35)),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(height: 0),
                  ),
                  Flexible(
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Card(
                        child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,

                          // itemCount: state.users.length,
                          itemCount:
                              20, // DELETE THIS AND UNCOMMENT above line ONCE user count is implemented
                          itemBuilder: ((context, index) {
                            // final selectedUser = UserData(
                            //     "",
                            //     false,
                            //     "",
                            //     "",
                            //     "",
                            //     "",
                            //     "",
                            //     List<PermissionData>.empty(growable: true));
                            bool isSelected =
                                _selectedUsersIndices.contains(index);
                            return Material(
                              color: isSelected ? Colors.grey : Colors.white,
                              child: ListTile(
                                key: ValueKey(index),
                                selected: _selectedUsersIndices.contains(index),
                                dense: true,
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedUsersIndices.remove(index);
                                    } else {
                                      _selectedUsersIndices.add(index);
                                    }
                                  });
                                },
                                // leading: ConstrainedBox(
                                //   constraints: const BoxConstraints(
                                //       maxHeight: 30,
                                //       maxWidth: 30,
                                //       minWidth: 30,
                                //       minHeight: 30),
                                // child:
                                //  SvgPicture.string(
                                //     FluttermojiFunctions()
                                //         .decodeFluttermojifromString(state.user.profilePicString)),
                                // ),
                                shape: const Border(top: BorderSide(width: 5)),
                                title: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      // "  ${state.user.firstName} ${state.user.lastName}",
                                      // text: state.user.displayName.toString(),
                                      text: "user first and last name",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 25)),
                                  TextSpan(
                                      text: "  user displayName",
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 20))
                                ])),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return ConfirmInviteUsersPopUp(
                              currentSpace: currentSpace,
                              numInvites: _selectedUsersIndices.length);
                        },
                      );
                    },
                    child: Text("Invite Users"),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
