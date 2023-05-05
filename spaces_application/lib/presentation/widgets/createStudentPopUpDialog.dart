import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/register/register_bloc.dart';
import 'package:spaces_application/business_logic/auth/register/register_event.dart';
import 'package:spaces_application/business_logic/auth/register/register_state.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';

class CreateStudentPopUpDialog extends StatelessWidget {
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
    return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 250, vertical: 225),
        backgroundColor: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
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
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Student Creation",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: textSize * 1.7))),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 0)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BlocProvider(
                      create: (context) => RegisterBloc(
                        authRepo: context.read<AuthRepository>(),
                      ),
                      child: _registerForm(context),
                    ),
                  )
                ]))
          ],
        ));
  }

  Widget _registerForm(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double userProfilePicConstraints = screenSize.width <= 500 ? 22 : 30;
    return BlocListener<RegisterBloc, RegisterState>(
        listenWhen: (previous, current) {
          if (current.formStatus == previous.formStatus) {
            return false;
          } else {
            return true;
          }
        },
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            MiscWidgets.showException(context, formStatus.exception.toString());
          } else if (formStatus is SubmissionSuccess) {
            // Navigate to new page
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(
            //     builder: (context) => HomeView(),
            //   ),
            Navigator.pop(context);
            MiscWidgets.showException(context, "ACCOUNT CREATION SUCCESS");
          }
        },
        child: Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _firstNameField(context),
                    const SizedBox(height: 10),
                    _lastNameField(context),
                    const SizedBox(height: 10),
                    _emailField(context),
                    const SizedBox(height: 10),
                    _parentEmailField(context),
                    const SizedBox(height: 10),
                    Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(children: [
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
                              child: Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: textSize * 0.9))),
                          const SizedBox(width: 10),
                          _registerButton(context)
                        ])),
                  ]),
            )));
  }

  Widget _emailField(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double userProfilePicConstraints = screenSize.width <= 500 ? 22 : 30;
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black, fontSize: textSize),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.grey, fontSize: textSize)),
            validator: (value) =>
                state.isValidEmail ? null : 'Not a valid Email',
            onChanged: (value) => context
                .read<RegisterBloc>()
                .add(RegisterEmailChanged(email: value)),
          ));
    });
  }

  Widget _parentEmailField(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double userProfilePicConstraints = screenSize.width <= 500 ? 22 : 30;
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black, fontSize: textSize),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'Parent Email',
                hintStyle: TextStyle(color: Colors.grey, fontSize: textSize)),
            validator: (value) =>
                state.isValidParentEmail ? null : 'Not a valid Parent Email',
            onChanged: (value) => context
                .read<RegisterBloc>()
                .add(RegisterParentEmailChanged(parentEmail: value)),
          ));
    });
  }

  Widget _firstNameField(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double userProfilePicConstraints = screenSize.width <= 500 ? 22 : 30;
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black, fontSize: textSize),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'First Name',
                hintStyle: TextStyle(color: Colors.grey, fontSize: textSize)),
            validator: (value) => state.isValidfirstName
                ? null
                : 'First Name must be between 2 - 20 characters',
            onChanged: (value) => context
                .read<RegisterBloc>()
                .add(RegisterFirstNameChanged(firstName: value)),
          ));
    });
  }

  Widget _lastNameField(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double userProfilePicConstraints = screenSize.width <= 500 ? 22 : 30;
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: TextFormField(
            style: TextStyle(color: Colors.black, fontSize: textSize),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'Last Name',
                hintStyle: TextStyle(color: Colors.grey, fontSize: textSize)),
            validator: (value) => state.isValidfirstName
                ? null
                : 'Last Name must be between 2 - 20 characters',
            onChanged: (value) => context
                .read<RegisterBloc>()
                .add(RegisterLastNameChanged(lastName: value)),
            onFieldSubmitted: (value) {
              if (_formKey.currentState!.validate()) {
                context.read<RegisterBloc>().add(RegisterSubmitted());
              }
            },
          ));
    });
  }

  Widget _registerButton(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double userProfilePicConstraints = screenSize.width <= 500 ? 22 : 30;
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<RegisterBloc>().add(RegisterSubmitted());
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  side: BorderSide(color: Colors.black, width: 0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              child: Text('Register Account',
                  style: TextStyle(
                      color: Colors.white, fontSize: textSize * 0.9)));
    });
  }
}
