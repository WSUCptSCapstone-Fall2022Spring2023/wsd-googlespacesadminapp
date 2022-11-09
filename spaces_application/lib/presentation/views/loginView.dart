import 'dart:ffi';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/login/login_bloc.dart';
import 'package:spaces_application/business_logic/auth/login/login_event.dart';
import 'package:spaces_application/business_logic/auth/login/login_state.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';

final Color bgColor = Color(0xFF4A4A57);
final Color boxColor = Color.fromRGBO(60, 60, 60, 1);

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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
              width: 400,
              height: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.cyclone_outlined,
                          size: 50, color: Colors.white),
                      Text("<Application Name>",
                          textScaleFactor: 2,
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  BlocProvider(
                    create: (context) => LoginBloc(
                      authRepo: context.read<AuthRepository>(),
                    ),
                    child: _loginForm(),
                  )
                ],
              )),
        ));
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
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
            MiscWidgets.showException(context, "LOGIN SUCCESS");
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
                    _passwordField(),
                    Padding(padding: EdgeInsets.all(2)),
                    _loginButton(),
                  ],
                ))));
  }

  Widget _emailField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0)),
            icon: Icon(Icons.person, color: Colors.white),
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
        onChanged: (value) =>
            context.read<LoginBloc>().add(LoginEmailChanged(email: value)),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        style: TextStyle(color: Colors.white),
        obscureText: true,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0)),
            icon: Icon(Icons.lock, color: Colors.white),
            hintText: 'Password',
            hintStyle: TextStyle(color: Colors.white)),
        // validator returns null when valid value is passed
        validator: (value) =>
            state.isValidPassword ? null : 'Password is too short',
        onChanged: (value) => context
            .read<LoginBloc>()
            .add(LoginPasswordChanged(password: value)),
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(LoginSubmitted());
                }
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom());
    });
  }
}
