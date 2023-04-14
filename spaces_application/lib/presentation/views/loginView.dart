import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/login/login_bloc.dart';
import 'package:spaces_application/business_logic/auth/login/login_event.dart';
import 'package:spaces_application/business_logic/auth/login/login_state.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';
import '../../data/repositories/userData_repository.dart';

class LoginView extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double imageWidth = screenSize.width * 0.7;
    final double imageHeight = screenSize.height * 0.4;
    final double textScaleFactor = screenSize.width < 500 ? 3 : 5;
    final double textSize = screenSize.width < 500 ? 12 : 20;
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Welcome to Slate",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontSize: textSize * 3.5)),
                if (screenSize.width > 500) const SizedBox(height: 30),
                Image.asset(
                  'assets/images/wahkiakumSchoolDistrictLogo.png',
                  width: imageWidth,
                  height: imageHeight,
                ),
                if (screenSize.width > 500) const SizedBox(height: 60),
                BlocProvider(
                  create: (context) => LoginBloc(
                    authRepo: context.read<AuthRepository>(),
                    userRepo: context.read<UserDataRepository>(),
                  ),
                  child: _loginForm(context),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Text.rich(TextSpan(
                    text: "Need an account? ",
                    style: TextStyle(color: Colors.black, fontSize: textSize),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Send Administration a Message",
                          style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              MiscWidgets.showException(
                                  context, "Send Admin Message");
                            })
                    ]))
              ],
            )),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _loginForm(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<LoginBloc, LoginState>(
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeView(
                  currentUserData: state.currentUser!,
                ),
              ),
            );
            MiscWidgets.showException(context, "LOGIN SUCCESS");
          }
        },
        child: Container(
            width: screenWidth > 500 ? 500 : screenWidth,
            alignment: Alignment.topCenter,
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _emailField(),
                    const SizedBox(height: 10),
                    _passwordField(),
                    const SizedBox(height: 20),
                    _loginButton(),
                  ],
                ))));
  }

  Widget _emailField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      final screenWidth = MediaQuery.of(context).size.width;
      final double fieldWidth = screenWidth < 500 ? screenWidth : 800;
      final double textSize = screenWidth < 500 ? 16 : 20;
      return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    blurRadius: 1,
                    spreadRadius: 0,
                    offset: Offset(2, 2))
              ]),
          child: SizedBox(
              width: fieldWidth,
              child: TextFormField(
                style: TextStyle(color: Colors.black, fontSize: textSize),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    prefixIcon:
                        Icon(Icons.email, color: Colors.black, size: textSize),
                    hintText: 'Email',
                    hintStyle:
                        TextStyle(color: Colors.black, fontSize: textSize)),
                // validator returns null when valid value is passed
                // alternative syntax:
                // String TextFormField.validator(value) {
                //   if state.isValidUsername()
                //     return null;
                //   else
                //     return "Username is too short";
                // }
                validator: (value) =>
                    state.isValidEmail ? null : 'Not a valid Email',
                onChanged: (value) => context
                    .read<LoginBloc>()
                    .add(LoginEmailChanged(email: value)),
              )));
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      final screenWidth = MediaQuery.of(context).size.width;
      final double fieldWidth = screenWidth < 500 ? screenWidth : 800;
      final double textSize = screenWidth < 500 ? 16 : 20;
      return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    blurRadius: 1,
                    spreadRadius: 0,
                    offset: Offset(2, 2))
              ]),
          child: SizedBox(
              width: fieldWidth,
              child: TextFormField(
                style: TextStyle(color: Colors.black, fontSize: textSize),
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    prefixIcon:
                        Icon(Icons.lock, color: Colors.black, size: textSize),
                    hintText: 'Password',
                    hintStyle:
                        TextStyle(color: Colors.black, fontSize: textSize)),
                // validator returns null when valid value is passed
                validator: (value) =>
                    state.isValidPassword ? null : 'Password is too short',
                onChanged: (value) => context
                    .read<LoginBloc>()
                    .add(LoginPasswordChanged(password: value)),
              )));
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      final screenWidth = MediaQuery.of(context).size.width;
      final double fieldWidth = screenWidth < 500 ? screenWidth : 800;
      final double textSize = screenWidth < 500 ? 16 : 20;
      return state.formStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : SizedBox(
              width: fieldWidth,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<LoginBloc>().add(LoginSubmitted());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: Text('Login',
                      style:
                          TextStyle(color: Colors.white, fontSize: textSize))),
            );
    });
  }
}
