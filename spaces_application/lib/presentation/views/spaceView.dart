import 'package:flutter/material.dart';
import 'package:spaces_application/presentation/widgets/navigation_drawer.dart';

import '../../data/models/spaceData.dart';

class SpaceView extends StatelessWidget {
  SpaceView({required this.space});
  final SpaceData space;
  final Color bgColor = Color.fromARGB(255, 49, 49, 49);
  final Color textColor = Color.fromARGB(255, 246, 246, 176);
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
          title: Text(space.spaceName),
          backgroundColor: bgColor,
        ),
        body: Center(child: Text(space.spaceDescription)));
  }
}
