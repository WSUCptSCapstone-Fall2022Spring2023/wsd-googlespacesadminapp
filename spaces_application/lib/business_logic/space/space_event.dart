import 'package:spaces_application/data/models/spaceData.dart';

import '../../data/models/userData.dart';

abstract class SpaceEvent {}

class PostMessageChanged extends SpaceEvent {
  final String message;

  PostMessageChanged({required this.message});
}

class LoadCurrentSpace extends SpaceEvent {
  SpaceData currentSpace;

  LoadCurrentSpace({required this.currentSpace});
}

class PostSubmitted extends SpaceEvent {}
