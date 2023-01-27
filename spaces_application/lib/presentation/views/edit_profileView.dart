import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';
import '../../business_logic/edit_profile/edit_space_bloc.dart';
import '../../business_logic/edit_profile/edit_space_event.dart';
import '../../business_logic/edit_profile/edit_space_state.dart';
import '../../data/models/userData.dart';
import '../../data/repositories/userData_repository.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({required this.currentUserData});
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color bgColor = Color.fromARGB(255, 12, 12, 12);
  final Color textColor = Color.fromARGB(255, 255, 255, 240);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);
  final UserData currentUserData;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       backgroundColor: bgColor,
  //       body: Container(
  //         alignment: Alignment.center,
  //         child: Container(
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.all(Radius.circular(40)),
  //               color: boxColor,
  //             ),
  //             width: 500,
  //             height: 350,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Icon(Icons.space_dashboard, size: 50, color: textColor),
  //                     Text("Create a Space",
  //                         textScaleFactor: 2,
  //                         style: TextStyle(color: textColor)),
  //                   ],
  //                 ),
  //                 BlocProvider(
  //                   create: (context) => EditProfileBloc(
  //                     spaceRepo: context.read<SpaceRepository>(),
  //                   ),
  //                   child: _createSpaceForm(),
  //                 )
  //               ],
  //             )),
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      backgroundColor: boxColor,
      insetPadding: EdgeInsets.all(10),
      content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: boxColor,
          ),
          width: 1000,
          height: 650,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.space_dashboard, size: 50, color: textColor),
                  Text("Edit Profile",
                      textScaleFactor: 2, style: TextStyle(color: textColor)),
                ],
              ),
              BlocProvider(
                create: (context) => EditProfileBloc(
                  userRepo: context.read<UserDataRepository>(),
                ),
                child: _createSpaceForm(),
              )
            ],
          )),
    );
  }

  Widget _createSpaceForm() {
    return BlocListener<EditProfileBloc, EditProfileState>(
        listenWhen: (previous, current) {
          if (current.formStatus == previous.formStatus)
            return false;
          else
            return true;
        },
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            MiscWidgets.showException(context, formStatus.exception.toString());
          } else if (formStatus is SubmissionSuccess) {
            // Navigate to new page
            context.read<UserDataRepository>().getCurrentUserData();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeView(
                  currentUserData: currentUserData,
                ),
              ),
            );
            MiscWidgets.showException(context, "SPACE CREATION SUCCESS");
          }
        },
        child: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: _firstNameField(currentUserData)),
                    Padding(padding: EdgeInsets.all(4)),
                    Padding(padding: EdgeInsets.all(2)),
                    _lastNameField(currentUserData),
                    Padding(padding: EdgeInsets.all(2)),
                    _displayNameField(currentUserData),
                    Padding(padding: EdgeInsets.all(2)),
                    _emailField(currentUserData),
                    Padding(padding: EdgeInsets.all(2)),
                    _parentEmailField(currentUserData),
                    Padding(padding: EdgeInsets.all(2)),
                    Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: _editProfileButton()),
                  ],
                ))));
  }

  Widget _firstNameField(UserData currentUser) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
      return TextFormField(
        initialValue: currentUser.firstName,
        readOnly: !(currentUser.isFaculty),
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 0.0)),
            hintText: "First Name",
            hintStyle: TextStyle(color: textColor)),
        validator: (value) =>
            state.isValidFirstName ? null : 'Must be between 2 - 20 characters',
        onChanged: (value) => context
            .read<EditProfileBloc>()
            .add(ProfileFirstNameChanged(firstName: value)),
      );
    });
  }

  Widget _lastNameField(UserData currentUser) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
      return TextFormField(
        initialValue: currentUser.lastName,
        readOnly: !(currentUser.isFaculty),
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 0.0)),
            hintText: "Last Name",
            hintStyle: TextStyle(color: textColor)),
        validator: (value) =>
            state.isValidLastName ? null : 'Must be between 2 - 20 characters',
        onChanged: (value) => context
            .read<EditProfileBloc>()
            .add(ProfileLastNameChanged(lastName: value)),
      );
    });
  }

  Widget _emailField(UserData currentUser) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
      return TextFormField(
        initialValue: currentUser.email,
        readOnly: true,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 0.0)),
            hintText: "Email",
            hintStyle: TextStyle(color: textColor)),
      );
    });
  }

  Widget _displayNameField(UserData currentUser) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
      return TextFormField(
        initialValue: currentUser.displayName,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 0.0)),
            hintText: "Display Name",
            hintStyle: TextStyle(color: textColor)),
        validator: (value) => state.isValidDisplayName
            ? null
            : 'Must be between 2 - 25 characters',
        onChanged: (value) => context
            .read<EditProfileBloc>()
            .add(ProfileDisplayNameChanged(displayName: value)),
      );
    });
  }

  Widget _parentEmailField(UserData currentUser) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
      return TextFormField(
        initialValue: currentUser.isFaculty ? "N/A" : currentUser.parentEmail,
        readOnly: true,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 0.0)),
            hintText: "Parent Email",
            hintStyle: TextStyle(color: textColor)),
      );
    });
  }

  Widget _editProfileButton() {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<EditProfileBloc>().add(ProfileSubmitted());
                }
              },
              child: Text('Submit  Profile'),
              style: ElevatedButton.styleFrom());
    });
  }
}
