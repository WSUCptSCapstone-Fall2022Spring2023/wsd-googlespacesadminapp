import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/register/register_bloc.dart';
import 'package:spaces_application/business_logic/auth/register/register_event.dart';
import 'package:spaces_application/business_logic/auth/register/register_state.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';

class RegisterView extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color bgColor = Color.fromARGB(255, 12, 12, 12);
  final Color textColor = Color.fromARGB(255, 255, 255, 240);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: Container(
          alignment: Alignment.center,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: Color.fromRGBO(40, 40, 40, 1),
              ),
              width: 500,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("<Application Name>",
                          textScaleFactor: 2,
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  BlocProvider(
                    create: (context) => RegisterBloc(
                      //!!!!!!!!!!!!!!!!!
                      authRepo: context.read<AuthRepository>(),
                    ),
                    child: _registerForm(),
                  )
                ],
              )),
        ));
  }

  Widget _registerForm() {
    return BlocListener<RegisterBloc, RegisterState>(
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeView(),
              ),
            );
            MiscWidgets.showException(context, "ACCOUNT CREATION SUCCESS");
          }
        },
        child: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _emailField(),
                    Padding(padding: EdgeInsets.all(4)),
                    //_passwordField(),
                    //Padding(padding: EdgeInsets.all(2)),
                    _registerButton(),
                  ],
                ))));
  }

  Widget _emailField() {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return TextFormField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0)),
            icon: Icon(Icons.email, color: Colors.white),
            hintText: 'Email',
            hintStyle: TextStyle(color: Colors.white)),
        // validator returns null when valid value is passed
        // alternative syntax:
        // String TextFormField.validator(value) {
        //   if state.isValidUsername()
        //     return null;
        //   else
        //     return "Username is too short";
        // }
        validator: (value) => state.isValidEmail ? null : 'Not a valid Email',
        onChanged: (value) => context
            .read<RegisterBloc>()
            .add(RegisterEmailChanged(email: value)),
      );
    });
  }

  // Widget _passwordField() {
  //   return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
  //     return TextFormField(
  //       style: TextStyle(color: Colors.white),
  //       obscureText: true,
  //       decoration: InputDecoration(
  //           enabledBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.white, width: 0.0)),
  //           icon: Icon(Icons.lock, color: Colors.white),
  //           hintText: 'Password',
  //           hintStyle: TextStyle(color: Colors.white)),
  //       // validator returns null when valid value is passed
  //       validator: (value) =>
  //           state.isValidPassword ? null : 'Password is too short',
  //       onChanged: (value) => context
  //           .read<RegisterBloc>()
  //           .add(LoginPasswordChanged(password: value)),
  //     );
  //   });
  // }

  Widget _registerButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<RegisterBloc>().add(RegisterSubmitted());
                }
              },
              child: Text('Register Account'),
              style: ElevatedButton.styleFrom());
    });
  }
}