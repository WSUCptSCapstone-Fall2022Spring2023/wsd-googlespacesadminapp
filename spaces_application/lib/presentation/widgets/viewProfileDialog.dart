import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:spaces_application/data/repositories/space_repository.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';

import '../../business_logic/space/space_bloc.dart';
import '../../business_logic/space/space_state.dart';
import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';

class ViewProfileDialog extends StatefulWidget {
  final UserData currentUserData;
  SpaceData? currentSpace;
  final UserData selectedUserData;
  ViewProfileDialog(
      {required this.currentSpace,
      required this.currentUserData,
      required this.selectedUserData});

  @override
  _ViewProfileDialogState createState() => _ViewProfileDialogState();
}

class _ViewProfileDialogState extends State<ViewProfileDialog> {
  _ViewProfileDialogState();
  bool _canComment = false;
  bool _canEdit = false;
  bool _canInvite = false;
  bool _canPost = false;
  bool _canRemove = false;

  late SpaceBloc _spaceBloc;

  @override
  void initState() {
    super.initState();
    _spaceBloc = SpaceBloc(
        spaceRepo: context.read<SpaceRepository>(),
        userRepo: context.read<UserDataRepository>(),
        currentUserData:
            widget.selectedUserData, // TODO: Check that this is right.
        currentSpaceData: widget.currentSpace!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _spaceBloc,
      child: BlocBuilder<SpaceBloc, SpaceState>(
        buildWhen: (previous, current) {
          if (ModalRoute.of(context)?.isCurrent == true) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state.permissions != null) {
            // TODO: Check that these are changing the correct user's perms
            _canComment = state.permissions!.canComment;
            _canEdit = state.permissions!.canEdit;
            _canInvite = state.permissions!.canInvite;
            _canPost = state.permissions!.canPost;
            _canRemove = state.permissions!.canRemove;
          }
          return Dialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 250, vertical: 350),
              backgroundColor: Colors.white,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
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
                              child: Text(
                                  "${state.currentUser.firstName} ${state.currentUser.lastName}'s Profile",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 35))),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: FluttermojiCircleAvatar(
                              radius: 100,
                              backgroundColor: Colors.grey[200],
                            ),
                          ),
                          if (state.currentUser.isFaculty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(state.currentUser.email,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 22)),
                                const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Icon(Icons.circle,
                                        color: Colors.red, size: 12)),
                                const Text("Faculty User",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 22)),
                              ],
                            ),
                          if (state.currentUser.isFaculty == false)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    '${state.currentUser.firstName} ${state.currentUser.lastName}',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 22)),
                                const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Icon(Icons.circle,
                                        color: Colors.red, size: 12)),
                                Text(state.currentUser.email,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 22)),
                                const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Icon(Icons.circle,
                                        color: Colors.red, size: 12)),
                                Text(state.currentUser.parentEmail,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 22)),
                              ],
                            ),
                          if (state.currentUser.isFaculty == false)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Student User",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 22)),
                              ],
                            ),
                          const SizedBox(height: 20),
                          const Text("Contact"),
                          const SizedBox(height: 10),
                          Text(state.currentUser.email),
                          const SizedBox(height: 20),
                          const Text("Biography"),
                          const SizedBox(height: 10),
                          Text(
                              "${state.currentUser.firstName} ${state.currentUser.lastName} has not added a bio."),
                          const SizedBox(height: 120),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(height: 0),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "${state.currentUser.firstName} ${state.currentUser.lastName}'s Permissions in ${state.currentSpace.spaceName}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20))),
                          SwitchListTile(
                            dense: true,
                            title: const Text('Can Comment'),
                            value: state.permissions!.canComment,
                            onChanged: (value) {
                              setState(() {
                                _canComment = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            dense: true,
                            title: const Text('Can Edit'),
                            value: state.permissions!.canEdit,
                            onChanged: (value) {
                              setState(() {
                                _canEdit = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            dense: true,
                            title: const Text('Can Invite'),
                            value: state.permissions!.canInvite,
                            onChanged: (value) {
                              setState(() {
                                _canInvite = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            dense: true,
                            title: const Text('Can Post'),
                            value: state.permissions!.canPost,
                            onChanged: (value) {
                              setState(() {
                                _canPost = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            dense: true,
                            title: const Text('Can Remove'),
                            value: state.permissions!.canRemove,
                            onChanged: (value) {
                              setState(() {
                                _canRemove = value;
                              });
                            },
                          ),
                          Row(children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                        color: Colors.black, width: 0.5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: const Text('Cancel',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18))),
                            const SizedBox(width: 10),
                            ElevatedButton(
                                onPressed: () {
                                  state.permissions!.canComment = _canComment;
                                  state.permissions!.canEdit = _canEdit;
                                  state.permissions!.canInvite = _canInvite;
                                  state.permissions!.canPost = _canPost;
                                  state.permissions!.canRemove = _canRemove;
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    side: const BorderSide(
                                        color: Colors.black, width: 0.5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: const Text('Save',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18))),
                          ])
                        ],
                      )),
                ],
              ));
        },
      ),
    );
  }
}
