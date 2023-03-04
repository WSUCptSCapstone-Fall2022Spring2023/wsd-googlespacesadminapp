import 'package:spaces_application/data/models/spaceData.dart';

import '../../data/models/userData.dart';

abstract class SpaceEvent {}

class PostMessageChanged extends SpaceEvent {
  final String message;

  PostMessageChanged({required this.message});
}

class InviteUser extends SpaceEvent {
  UserData invitedUser;

  InviteUser({required this.invitedUser});
}

class LoadPosts extends SpaceEvent {}

class DeleteSpace extends SpaceEvent {}

class GetUsers extends SpaceEvent {}

class PostSubmitted extends SpaceEvent {}
