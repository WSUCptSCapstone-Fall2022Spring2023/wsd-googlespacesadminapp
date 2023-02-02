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
import '../widgets/navigation_drawer.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({required this.currentUserData});
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color bgColor = Color.fromARGB(255, 12, 12, 12);
  final Color textColor = const Color.fromARGB(255, 14, 4, 104);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);
  final Color navyBlue = const Color.fromARGB(255, 14, 4, 104);
  final Color salmon = const Color.fromARGB(255, 252, 117, 106);

  final UserData currentUserData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavigationDrawer(
        currentUserData: currentUserData,
      ),
      appBar: AppBar(
        elevation: 15,
        title: const Text("Your Profile Page"),
        backgroundColor: navyBlue,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          Icon(Icons.account_circle, size: 150, color: salmon),
          const SizedBox(height: 15),
          Text("${currentUserData.firstName} ${currentUserData.lastName}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(currentUserData.email,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black)),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(height: 0),
          ),
          BlocProvider(
            create: (context) => EditProfileBloc(
              userRepo: context.read<UserDataRepository>(),
            ),
            child: _createSpaceForm(),
          )
        ],
      ),
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
        child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: salmon),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Form(
                    key: _formKey,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _firstNameField(currentUserData),
                            _lastNameField(currentUserData),
                            _displayNameField(currentUserData),
                            _emailField(currentUserData),
                            _parentEmailField(currentUserData),
                            Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: _editProfileButton()),
                          ],
                        ))))));
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
            hintStyle: TextStyle(color: navyBlue)),
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
