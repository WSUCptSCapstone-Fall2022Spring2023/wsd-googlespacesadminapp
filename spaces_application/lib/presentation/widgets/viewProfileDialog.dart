import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/space/space_event.dart';
import 'package:spaces_application/data/repositories/space_repository.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/space/space_bloc.dart';
import '../../business_logic/space/space_state.dart';
import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';
import '../views/homeView.dart';

class ViewProfileDialog extends StatefulWidget {
  final UserData selectedUserData;
  ViewProfileDialog({required this.selectedUserData});

  @override
  _ViewProfileDialogState createState() => _ViewProfileDialogState();
}

class _ViewProfileDialogState extends State<ViewProfileDialog> {
  _ViewProfileDialogState();
  bool isEnable = true;

  late SpaceBloc _spaceBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    return BlocConsumer<SpaceBloc, SpaceState>(
      listener: (context, state) {
        final dataStatus = state.kickUserStatus;
        if (dataStatus is SubmissionSuccess) {
          if (widget.selectedUserData.uid == state.currentUser.uid) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeView(
                currentUserData: state.currentUser,
              ),
            ));
          } else {
            Navigator.pop(context);
          }
        } else if (dataStatus is SubmissionFailed) {
          MiscWidgets.showException(context, dataStatus.exception.toString());
        }
      },
      builder: (context, state) {
        final permission = widget.selectedUserData.spacesPermissions
            .firstWhere((element) => element.spaceID == state.currentSpace.sid);
        isEnable =
            !(widget.selectedUserData.isFaculty) && state.currentUser.isFaculty;
        return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 250),
            backgroundColor: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: state.currentUser.isFaculty ||
                            state.currentUser.uid == widget.selectedUserData.uid
                        ? ScreenHeight * 0.75
                        : ScreenHeight * 0.6,
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
                                "${widget.selectedUserData.displayName}'s Profile",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 35))),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxHeight: 100,
                                maxWidth: 100,
                                minWidth: 100,
                                minHeight: 100),
                            child: SvgPicture.string(FluttermojiFunctions()
                                .decodeFluttermojifromString(
                                    widget.selectedUserData.profilePicString)),
                          ),
                        ),
                        if (widget.selectedUserData.isFaculty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.selectedUserData.email,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 22)),
                              const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(Icons.circle,
                                      color: Colors.red, size: 12)),
                              const Text("Faculty User",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 22)),
                            ],
                          ),
                        if (widget.selectedUserData.isFaculty == false)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  '${widget.selectedUserData.firstName} ${widget.selectedUserData.lastName}',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 22)),
                              const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(Icons.circle,
                                      color: Colors.red, size: 12)),
                              Text(widget.selectedUserData.email,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 22)),
                              const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(Icons.circle,
                                      color: Colors.red, size: 12)),
                              Text(widget.selectedUserData.parentEmail,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 22)),
                            ],
                          ),
                        if (widget.selectedUserData.isFaculty == false)
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
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(height: 0),
                        ),
                        if (state.currentUser.isFaculty ||
                            state.currentUser.uid ==
                                widget.selectedUserData.uid)
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "${widget.selectedUserData.displayName}'s Permissions in ${state.currentSpace.spaceName}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20))),
                        const SizedBox(height: 10),
                        if (state.currentUser.isFaculty ||
                            state.currentUser.uid ==
                                widget.selectedUserData.uid)
                          SwitchListTile(
                            dense: true,
                            title: const Text('Can Comment'),
                            value: permission.canComment,
                            onChanged: (value) {
                              setState(() {
                                isEnable ? permission.canComment = value : null;
                              });
                            },
                          ),
                        if (state.currentUser.isFaculty ||
                            state.currentUser.uid ==
                                widget.selectedUserData.uid)
                          SwitchListTile(
                            dense: true,
                            title: const Text('Can Edit'),
                            value: permission.canEdit,
                            onChanged: (value) {
                              setState(() {
                                isEnable ? permission.canEdit = value : null;
                              });
                            },
                          ),
                        if (state.currentUser.isFaculty ||
                            state.currentUser.uid ==
                                widget.selectedUserData.uid)
                          SwitchListTile(
                            dense: true,
                            title: const Text('Can Invite'),
                            value: permission.canInvite,
                            onChanged: (value) {
                              setState(() {
                                isEnable ? permission.canInvite = value : null;
                              });
                            },
                          ),
                        if (state.currentUser.isFaculty ||
                            state.currentUser.uid ==
                                widget.selectedUserData.uid)
                          SwitchListTile(
                            dense: true,
                            title: const Text('Can Post'),
                            value: permission.canPost,
                            onChanged: (value) {
                              setState(() {
                                isEnable ? permission.canPost = value : null;
                              });
                            },
                          ),
                        if (state.currentUser.isFaculty ||
                            state.currentUser.uid ==
                                widget.selectedUserData.uid)
                          SwitchListTile(
                            dense: true,
                            title: const Text('Can Remove'),
                            value: permission.canRemove,
                            onChanged: (value) {
                              setState(() {
                                isEnable ? permission.canRemove = value : null;
                              });
                            },
                          ),
                        const SizedBox(height: 25),
                        Row(children: [
                          if (state.currentUser.isFaculty)
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
                          if (state.currentUser.isFaculty)
                            ElevatedButton(
                                onPressed: () {
                                  context.read<SpaceBloc>().add(
                                      UpdatePermissions(
                                          selectedUserID:
                                              widget.selectedUserData.uid,
                                          canComment: permission.canComment,
                                          canEdit: permission.canEdit,
                                          canInvite: permission.canInvite,
                                          canRemove: permission.canRemove,
                                          canPost: permission.canPost));
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
                          const SizedBox(width: 10),
                          if (widget.selectedUserData.uid ==
                                  state.currentUser.uid ||
                              state.currentUser.isFaculty)
                            ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: ((_) {
                                        return BlocProvider.value(
                                            value: BlocProvider.of<SpaceBloc>(
                                                context),
                                            child: Dialog(
                                                insetPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 250),
                                                backgroundColor: Colors.white,
                                                child: Stack(
                                                    alignment: Alignment.center,
                                                    children: <Widget>[
                                                      Container(
                                                          width:
                                                              double.infinity,
                                                          height: ScreenHeight *
                                                              0.25,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child: Column(
                                                              children: [
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child:
                                                                        IconButton(
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .close,
                                                                          color: Colors
                                                                              .black,
                                                                          size:
                                                                              25),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    )),
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child: widget.selectedUserData.uid ==
                                                                            state
                                                                                .currentUser.uid
                                                                        ? Text(
                                                                            "Are you sure you want to leave this space?",
                                                                            style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.normal,
                                                                                fontSize: 35))
                                                                        : Text("Are you sure you want to kick this user from the space?", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 35))),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 20),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topCenter,
                                                                    child: BlocBuilder<
                                                                        SpaceBloc,
                                                                        SpaceState>(
                                                                      builder:
                                                                          (context,
                                                                              state) {
                                                                        if (state.kickUserStatus
                                                                            is FormSubmitting) {
                                                                          return CircularProgressIndicator();
                                                                        } else {
                                                                          return ElevatedButton(
                                                                              onPressed: () {
                                                                                context.read<SpaceBloc>().add(KickUser(uid: widget.selectedUserData.uid));
                                                                              },
                                                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, side: const BorderSide(color: Colors.black, width: 0.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                                              child: widget.selectedUserData.uid == state.currentUser.uid ? const Text('Leave', style: TextStyle(color: Colors.white, fontSize: 18)) : const Text('Kick', style: TextStyle(color: Colors.white, fontSize: 18)));
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]))
                                                    ])));
                                      }));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    side: const BorderSide(
                                        color: Colors.black, width: 0.5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: widget.selectedUserData.uid ==
                                        state.currentUser.uid
                                    ? const Text('Leave',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18))
                                    : const Text('Kick',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18))),
                        ])
                      ],
                    )),
              ],
            ));
      },
    );
  }
}
