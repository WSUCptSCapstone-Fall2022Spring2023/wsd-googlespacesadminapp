import 'package:flutter/cupertino.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';
import 'package:spaces_application/data/models/commentData.dart';

import '../../data/models/postData.dart';
import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';

class SpaceState {
  final String newPost;
  final String newComment;
  final List<UserData> users;
  final FormSubmissionStatus postFormStatus;
  final FormSubmissionStatus inviteUserStatus;
  final FormSubmissionStatus commentFormStatus;
  final DataRetrievalStatus getPostsStatus;
  final DataRetrievalStatus deleteSpaceStatus;
  final DataRetrievalStatus getUsersStatus;
  final DataRetrievalStatus getCommentsStatus;
  final DataRetrievalStatus deletePostStatus;
  final SpaceData currentSpace;
  final UserData currentUser;
  final PostData? selectedPost;

  SpaceState({
    this.newPost = '',
    this.newComment = '',
    this.selectedPost,
    List<UserData>? users,
    this.postFormStatus = const InitialFormStatus(),
    this.inviteUserStatus = const InitialFormStatus(),
    this.commentFormStatus = const InitialFormStatus(),
    this.getPostsStatus = const InitialRetrievalStatus(),
    this.deleteSpaceStatus = const InitialRetrievalStatus(),
    this.getUsersStatus = const InitialRetrievalStatus(),
    this.getCommentsStatus = const InitialRetrievalStatus(),
    this.deletePostStatus = const InitialRetrievalStatus(),
    required this.currentSpace,
    required this.currentUser,
  }) : users = users ?? List<UserData>.empty();

  SpaceState copyWith({
    String? newPost,
    String? newComment,
    List<UserData>? users,
    PostData? selectedPost,
    FormSubmissionStatus? postFormStatus,
    FormSubmissionStatus? inviteUserStatus,
    FormSubmissionStatus? commentFormStatus,
    DataRetrievalStatus? deleteSpaceStatus,
    DataRetrievalStatus? getUsersStatus,
    DataRetrievalStatus? getPostsStatus,
    DataRetrievalStatus? getCommentsStatus,
    DataRetrievalStatus? deletePostStatus,
    UserData? currentUser,
    SpaceData? currentSpace,
  }) {
    return SpaceState(
      newPost: newPost ?? this.newPost,
      newComment: newComment ?? this.newComment,
      users: users ?? this.users,
      selectedPost: selectedPost ?? this.selectedPost,
      postFormStatus: postFormStatus ?? this.postFormStatus,
      inviteUserStatus: inviteUserStatus ?? this.inviteUserStatus,
      commentFormStatus: commentFormStatus ?? this.commentFormStatus,
      deletePostStatus: deletePostStatus ?? this.deletePostStatus,
      getPostsStatus: getPostsStatus ?? this.getPostsStatus,
      deleteSpaceStatus: deleteSpaceStatus ?? this.deleteSpaceStatus,
      getUsersStatus: getUsersStatus ?? this.getUsersStatus,
      getCommentsStatus: getCommentsStatus ?? this.getCommentsStatus,
      currentSpace: currentSpace ?? this.currentSpace,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
