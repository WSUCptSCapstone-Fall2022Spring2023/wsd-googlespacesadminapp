import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:spaces_application/business_logic/space/space_event.dart';
import 'package:spaces_application/data/repositories/space_repository.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../business_logic/space/space_bloc.dart';
import '../../business_logic/space/space_state.dart';
import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';

class ViewProfileDialog extends StatefulWidget {
  final UserData selectedUserData;
  ViewProfileDialog({required this.selectedUserData});

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
  }

  @override
  Widget build(BuildContext context) {
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<SpaceBloc, SpaceState>(
      builder: (context, state) {
        final permission = widget.selectedUserData.spacesPermissions
            .firstWhere((element) => element.spaceID == state.currentSpace.sid);
        _canComment = permission.canComment;
        _canEdit = permission.canEdit;
        _canInvite = permission.canInvite;
        _canPost = permission.canPost;
        _canRemove = permission.canRemove;
        return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 250),
            backgroundColor: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: ScreenHeight * 0.8,
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
                        const SizedBox(height: 20),
                        const Text("Biography"),
                        const SizedBox(height: 10),
                        Text(
                            "${widget.selectedUserData.firstName} ${widget.selectedUserData.lastName} has not added a bio."),
                        const SizedBox(height: 30),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(height: 0),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "${widget.selectedUserData.firstName} ${widget.selectedUserData.lastName}'s Permissions in ${state.currentSpace.spaceName}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20))),
                        SwitchListTile(
                          dense: true,
                          title: const Text('Can Comment'),
                          value: permission.canComment,
                          onChanged: (value) {
                            setState(() {
                              _canComment = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          dense: true,
                          title: const Text('Can Edit'),
                          value: permission.canEdit,
                          onChanged: (value) {
                            setState(() {
                              _canEdit = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          dense: true,
                          title: const Text('Can Invite'),
                          value: permission.canInvite,
                          onChanged: (value) {
                            setState(() {
                              _canInvite = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          dense: true,
                          title: const Text('Can Post'),
                          value: permission.canPost,
                          onChanged: (value) {
                            setState(() {
                              _canPost = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          dense: true,
                          title: const Text('Can Remove'),
                          value: permission.canRemove,
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
                                      borderRadius: BorderRadius.circular(5))),
                              child: const Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18))),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              onPressed: () {
                                context.read<SpaceBloc>().add(UpdatePermissions(
                                    selectedUserID: widget.selectedUserData.uid,
                                    canComment: _canComment,
                                    canEdit: _canEdit,
                                    canInvite: _canInvite,
                                    canRemove: _canRemove,
                                    canPost: _canPost));
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  side: const BorderSide(
                                      color: Colors.black, width: 0.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              child: const Text('Save',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18))),
                        ])
                      ],
                    )),
              ],
            ));
      },
    );
  }
}
