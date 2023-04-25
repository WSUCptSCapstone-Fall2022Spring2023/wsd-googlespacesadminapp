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

class LoadMoreSpacePosts extends SpaceEvent {}

class LoadPostComments extends SpaceEvent {
  PostData selectedPost;

  LoadPostComments({required this.selectedPost});
}

class DeleteSpace extends SpaceEvent {}

class GetSpaceUsers extends SpaceEvent {}

class GetNonSpaceUsers extends SpaceEvent {}

class PostSubmitted extends SpaceEvent {}

class CommentSubmitted extends SpaceEvent {}

class ChangePrivacy extends SpaceEvent {}

class GetNewPosts extends SpaceEvent {
  DateTime lastPostTime;

  GetNewPosts({required this.lastPostTime});
}

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

class UpdatePermissions extends SpaceEvent {
  bool canComment;
  bool canEdit;
  bool canInvite;
  bool canRemove;
  bool canPost;
  String selectedUserID;

  UpdatePermissions(
      {required this.selectedUserID,
      required this.canComment,
      required this.canEdit,
      required this.canInvite,
      required this.canRemove,
      required this.canPost});
}

class KickUser extends SpaceEvent {
  String uid;

  KickUser({required this.uid});
}

class GetUserHistory extends SpaceEvent {
  String displayName;
  String email;
  String uid;
  String month;
  String year;
  GetUserHistory(
      {required this.displayName,
      required this.email,
      required this.uid,
      required this.month,
      required this.year});
}
