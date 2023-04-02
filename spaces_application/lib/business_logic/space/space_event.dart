import 'package:spaces_application/data/models/spaceData.dart';

import '../../data/models/commentData.dart';
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

class EditFieldChanged extends SpaceEvent {
  final String message;

  EditFieldChanged({required this.message});
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

class EditComment extends SpaceEvent {
  String newContents;
  CommentData selectedComment;

  EditComment({required this.newContents, required this.selectedComment});
}

class RemoveComment extends SpaceEvent {
  CommentData selectedComment;

  RemoveComment({required this.selectedComment});
}

class EditPost extends SpaceEvent {
  String newContents;
  PostData selectedPost;

  EditPost({required this.newContents, required this.selectedPost});
}

class RemovePost extends SpaceEvent {
  PostData selectedPost;

  RemovePost({required this.selectedPost});
}
