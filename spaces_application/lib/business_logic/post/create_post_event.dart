import 'package:spaces_application/data/models/spaceData.dart';

import '../../data/models/userData.dart';

abstract class PostEvent {}

class PostMessageChanged extends PostEvent {
  final String message;

  PostMessageChanged({required this.message});
}

class LoadCurrentSpace extends PostEvent {
  SpaceData currentSpace;

  LoadCurrentSpace({required this.currentSpace});
}

class PostSubmitted extends PostEvent {}
