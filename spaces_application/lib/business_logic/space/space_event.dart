import 'package:spaces_application/data/models/spaceData.dart';

import '../../data/models/userData.dart';

abstract class SpaceEvent {}

class PostMessageChanged extends SpaceEvent {
  final String message;

  PostMessageChanged({required this.message});
}

class LoadPosts extends SpaceEvent {
  SpaceData currentSpace;

  LoadPosts({required this.currentSpace});
}

class DeleteSpace extends SpaceEvent {
  SpaceData currentSpace;

  DeleteSpace({required this.currentSpace});
}

class InviteUser extends SpaceEvent {
  UserData invitedUser;

  InviteUser({required this.invitedUser});
}

class GetUsers extends SpaceEvent {}

class PostSubmitted extends SpaceEvent {}
