import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/login/login_bloc.dart';
import 'package:spaces_application/business_logic/auth/login/login_event.dart';
import 'package:spaces_application/business_logic/auth/login/login_state.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/presentation/widgets/navigation_drawer.dart';

class SpaceView extends StatelessWidget {
  SpaceView({required this.id});
  final String id;
  final Color bgColor = Color.fromARGB(255, 49, 49, 49);
  final Color textColor = Color.fromARGB(255, 255, 255, 240);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);

  @override
  Widget build(BuildContext context) {
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: bgColor,
        drawer: NavigationDrawer(),
        appBar: AppBar(
          elevation: 15,
          title: BlocProvider(
              create: (context) => LoginBloc(
                    authRepo: context.read<AuthRepository>(),
                  )),
          backgroundColor: bgColor,
        ),
        body: Center(child: WebView(initialUrl: 'https://wahksd.k12.wa.us/')));
  }
}
