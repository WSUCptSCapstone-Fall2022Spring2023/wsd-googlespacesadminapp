import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:spaces_application/presentation/widgets/navigation_drawer.dart';

import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';

class SpaceView extends StatelessWidget {
  SpaceView({required this.space, required this.currentUserData});
  final SpaceData space;
  final UserData currentUserData;
  final Color bgColor = Color.fromARGB(255, 49, 49, 49);
  final Color textColor = Color.fromARGB(255, 246, 246, 176);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);

  @override
  Widget build(BuildContext context) {
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      drawer: NavigationDrawer(
        currentUserData: currentUserData,
      ),
      appBar: AppBar(
        elevation: 15,
        title: Text(space.spaceName),
        backgroundColor: bgColor,
      ),
      body: 
      Chat(
        messages: ,
        showUserAvatars: true,
        showUserNames: true,
        user: types.User(id: currentUserData.uid),
      ),
    );
  }
}
