import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/login/login_bloc.dart';
import 'package:spaces_application/business_logic/auth/login/login_event.dart';
import 'package:spaces_application/business_logic/auth/login/login_state.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/presentation/widgets/navigation_drawer.dart';

final Color bgColor = Color(0xFF4A4A57);

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        drawer: NavigationDrawer(),
        appBar: AppBar(
          elevation: 15,
          title: Text("Home Page"),
          backgroundColor: Colors.black,
        ),
        body: Center(child: Text('Home Page')));
  }
}
