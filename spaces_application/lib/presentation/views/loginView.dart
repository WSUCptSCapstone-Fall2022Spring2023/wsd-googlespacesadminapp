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

  final Color darkViolet = Color.fromARGB(255, 9, 5, 5);
  final Color navyBlue = Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = Color.fromARGB(255, 45, 40, 138);
  final Color majorelleBlue = Color.fromARGB(255, 86, 85, 221);
  final Color salmon = Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = Color.fromARGB(255, 22, 12, 113);
  final Color lightPink = Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = Color.fromARGB(255, 255, 255, 240);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.center,
                    child: Text("Welcome to Slate",
                        textScaleFactor: 5,
                        style: TextStyle(
                          color: picoteeBlue,
                        ))),
                const SizedBox(height: 25),
                Image.asset(
                  'assets/images/landingPageImage.jpg',
                  width: 400,
                  height: 400,
                ),
                const SizedBox(height: 50),
                BlocProvider(
                  create: (context) => LoginBloc(
                    authRepo: context.read<AuthRepository>(),
                    userRepo: context.read<UserDataRepository>(),
                  ),
                  child: _loginForm(),
                ),
                Padding(padding: EdgeInsets.only(top: 6)),
                Text.rich(TextSpan(
                    text: "Need an account? ",
                    style: const TextStyle(color: Colors.black, fontSize: 20),
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
            ))),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _loginForm() {
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
            alignment: Alignment.topCenter,
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _emailField(),
                        const SizedBox(height: 10),
                        _passwordField(),
                        const SizedBox(height: 10),
                        _loginButton(),
                      ],
                    )))));
  }

  Widget _emailField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    color: picoteeBlue,
                    blurRadius: 1,
                    spreadRadius: 0,
                    offset: const Offset(2, 2))
              ]),
          child: SizedBox(
              width: 600,
              child: TextFormField(
                style: TextStyle(color: picoteeBlue, fontSize: 26),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    prefixIcon: Icon(Icons.email, color: picoteeBlue),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: picoteeBlue, fontSize: 26)),
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
      return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    color: picoteeBlue,
                    blurRadius: 1,
                    spreadRadius: 0,
                    offset: const Offset(2, 2))
              ]),
          child: SizedBox(
              width: 600,
              child: TextFormField(
                style: TextStyle(color: picoteeBlue, fontSize: 26),
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    prefixIcon: Icon(Icons.lock, color: picoteeBlue),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: picoteeBlue, fontSize: 26)),
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
      return state.formStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : SizedBox(
              width: 200,
              height: 46,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<LoginBloc>().add(LoginSubmitted());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: salmon,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 26))),
            );
    });
  }
}
