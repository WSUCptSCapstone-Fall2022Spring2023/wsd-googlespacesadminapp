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
  final List<UserData> spaceUsers;
  final List<UserData> allUsers;
  final FormSubmissionStatus postFormStatus;
  final FormSubmissionStatus inviteUserStatus;
  final FormSubmissionStatus commentFormStatus;
  final FormSubmissionStatus editPostFormStatus;
  final FormSubmissionStatus editCommentFormStatus;
  final FormSubmissionStatus deleteCommentFormStatus;
  final DataRetrievalStatus getPostsStatus;
  final DataRetrievalStatus deleteSpaceStatus;
  final DataRetrievalStatus getUsersStatus;
  final DataRetrievalStatus getCommentsStatus;
  final DataRetrievalStatus deletePostStatus;
  final DataRetrievalStatus getAllUsersStatus;
  final SpaceData currentSpace;
  final UserData currentUser;
  final PostData? selectedPost;

  SpaceState({
    this.newPost = '',
    this.newComment = '',
    this.selectedPost,
    List<UserData>? spaceUsers,
    List<UserData>? allUsers,
    this.postFormStatus = const InitialFormStatus(),
    this.inviteUserStatus = const InitialFormStatus(),
    this.commentFormStatus = const InitialFormStatus(),
    this.deleteCommentFormStatus = const InitialFormStatus(),
    this.editCommentFormStatus = const InitialFormStatus(),
    this.editPostFormStatus = const InitialFormStatus(),
    this.getPostsStatus = const InitialRetrievalStatus(),
    this.deleteSpaceStatus = const InitialRetrievalStatus(),
    this.getUsersStatus = const InitialRetrievalStatus(),
    this.getCommentsStatus = const InitialRetrievalStatus(),
    this.deletePostStatus = const InitialRetrievalStatus(),
    this.getAllUsersStatus = const InitialRetrievalStatus(),
    required this.currentSpace,
    required this.currentUser,
  })  : spaceUsers = spaceUsers ?? List<UserData>.empty(),
        allUsers = allUsers ?? List<UserData>.empty();

  SpaceState copyWith({
    String? newPost,
    String? newComment,
    List<UserData>? spaceUsers,
    List<UserData>? allUsers,
    PostData? selectedPost,
    FormSubmissionStatus? postFormStatus,
    FormSubmissionStatus? inviteUserStatus,
    FormSubmissionStatus? commentFormStatus,
    FormSubmissionStatus? editCommentFormStatus,
    FormSubmissionStatus? editPostFormStatus,
    FormSubmissionStatus? deleteCommentFormStatus,
    DataRetrievalStatus? deleteSpaceStatus,
    DataRetrievalStatus? getUsersStatus,
    DataRetrievalStatus? getPostsStatus,
    DataRetrievalStatus? getCommentsStatus,
    DataRetrievalStatus? deletePostStatus,
    DataRetrievalStatus? getAllUsersStatus,
    UserData? currentUser,
    SpaceData? currentSpace,
  }) {
    return SpaceState(
      newPost: newPost ?? this.newPost,
      newComment: newComment ?? this.newComment,
      spaceUsers: spaceUsers ?? this.spaceUsers,
      allUsers: allUsers ?? this.allUsers,
      selectedPost: selectedPost ?? this.selectedPost,
      postFormStatus: postFormStatus ?? this.postFormStatus,
      inviteUserStatus: inviteUserStatus ?? this.inviteUserStatus,
      commentFormStatus: commentFormStatus ?? this.commentFormStatus,
      editCommentFormStatus:
          editCommentFormStatus ?? this.editCommentFormStatus,
      editPostFormStatus: editPostFormStatus ?? this.editPostFormStatus,
      deleteCommentFormStatus:
          deleteCommentFormStatus ?? this.deleteCommentFormStatus,
      deletePostStatus: deletePostStatus ?? this.deletePostStatus,
      getPostsStatus: getPostsStatus ?? this.getPostsStatus,
      deleteSpaceStatus: deleteSpaceStatus ?? this.deleteSpaceStatus,
      getUsersStatus: getUsersStatus ?? this.getUsersStatus,
      getAllUsersStatus: getAllUsersStatus ?? this.getAllUsersStatus,
      getCommentsStatus: getCommentsStatus ?? this.getCommentsStatus,
      currentSpace: currentSpace ?? this.currentSpace,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
