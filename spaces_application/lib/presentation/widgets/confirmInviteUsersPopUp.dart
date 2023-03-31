import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/space/space_bloc.dart';
import 'package:spaces_application/business_logic/space/space_event.dart';
import 'package:spaces_application/business_logic/space/space_state.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';

class ConfirmInviteUsersPopUp extends StatelessWidget {
  ConfirmInviteUsersPopUp(
      {required this.numInvites, required this.selectedUsers});
  final int numInvites;
  final List<UserData> selectedUsers;
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpaceBloc, SpaceState>(
      builder: (context, state) {
        return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Dialog(
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 150, vertical: 250),
                backgroundColor: Colors.white,
                child: Stack(alignment: Alignment.center, children: <Widget>[
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
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
                          child: Text("Confirm invite Users",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 35)),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                              "Are you sure you wish to invite ${numInvites.toString()} users to ${state.currentSpace.spaceName}?"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<SpaceBloc>()
                                .add(InviteUsers(invitedUsers: selectedUsers));
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text("Invite Users"),
                        )
                      ]))
                ])));
      },
    );
  }
}
