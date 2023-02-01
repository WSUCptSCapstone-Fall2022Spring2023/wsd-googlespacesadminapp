import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:spaces_application/presentation/widgets/navigation_drawer.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';

class SpaceView extends StatelessWidget {
  SpaceView({required this.space, required this.currentUserData});
  final SpaceData space;
  final UserData currentUserData;
  final Color bgColor = Color.fromARGB(255, 49, 49, 49);
  final Color textColor = Color.fromARGB(255, 246, 246, 176);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);
  List<types.Message> _messages = [];

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
      body: Chat(
        messages: _messages,
        showUserAvatars: true,
        showUserNames: true,
        user: types.User(id: currentUserData.uid),
        onSendPressed: (PartialText) {},
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: types.User(id: currentUserData.uid),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    _messages = messages;
  }

  void _addMessage(types.Message message) {
    _messages.insert(0, message);
  }
}
