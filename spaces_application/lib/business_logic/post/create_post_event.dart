abstract class CreatePostEvent {}

class PostMessageChanged extends CreatePostEvent {
  final String message;

  PostMessageChanged({required this.message});
}

class PostUserIDChanged extends CreatePostEvent {
  final String userID;

  PostUserIDChanged({required this.userID});
}

class PostSpaceIDChanged extends CreatePostEvent {
  final String spaceID;

  PostSpaceIDChanged({required this.spaceID});
}

class CreatePostSubmitted extends CreatePostEvent {}
