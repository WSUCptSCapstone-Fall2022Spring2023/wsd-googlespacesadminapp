import 'package:spaces_application/data/models/spaceData.dart';

import '../../data/models/postData.dart';
import '../../data/models/userData.dart';

abstract class SpaceEvent {}

class PostMessageChanged extends SpaceEvent {
  final String message;

  PostMessageChanged({required this.message});
}

class CommentMessageChanged extends SpaceEvent {
  final String message;

  CommentMessageChanged({required this.message});
}

class InviteUser extends SpaceEvent {
  UserData invitedUser;

  InviteUser({required this.invitedUser});
}

class LoadSpacePosts extends SpaceEvent {}

class LoadPostComments extends SpaceEvent {
  PostData selectedPost;

  LoadPostComments({required this.selectedPost});
}

class DeleteSpace extends SpaceEvent {}

class GetUsers extends SpaceEvent {}

class PostSubmitted extends SpaceEvent {}

class CommentSubmitted extends SpaceEvent {}

class RemovePost extends SpaceEvent {
  PostData selectedPost;

  RemovePost({required this.selectedPost});
}
