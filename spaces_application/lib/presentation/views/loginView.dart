import 'dart:ffi';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        _usernameField(),
        _passwordField(),
      ]),
    ));
  }

  Widget _usernameField() {
<<<<<<< Updated upstream
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Username',
      ),
      validator: (value) => null,
    );
=======
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Username',
        ),
        // validator returns null when valid value is passed
        // alternative syntax:
        // String TextFormField.validator(value) {
        //   if state.isValidUsername()
        //     return null;
        //   else
        //     return "Username is too short";
        // }
        validator: (value) =>
            state.isValidUsername ? null : 'Username is too short',
        onChanged: (value) => context
            .read<LoginBloc>()
            .add(LoginUsernameChanged(username: value)),
      );
    });
>>>>>>> Stashed changes
  }

  Widget _passwordField() {
    return TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.security),
          hintText: 'Password',
        ));
  }
}
