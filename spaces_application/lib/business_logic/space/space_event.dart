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

class InviteUsers extends SpaceEvent {
  List<UserData> invitedUsers;

  InviteUsers({required this.invitedUsers});
}

class LoadSpacePosts extends SpaceEvent {}

class LoadPostComments extends SpaceEvent {
  PostData selectedPost;

  LoadPostComments({required this.selectedPost});
}

class DeleteSpace extends SpaceEvent {}

class GetSpaceUsers extends SpaceEvent {}

class GetAllUsers extends SpaceEvent {}

class PostSubmitted extends SpaceEvent {}

class CommentSubmitted extends SpaceEvent {}

class RemovePost extends SpaceEvent {
  PostData selectedPost;

  RemovePost({required this.selectedPost});
}
