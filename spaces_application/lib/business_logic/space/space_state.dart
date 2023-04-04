import 'package:flutter/cupertino.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';
import 'package:spaces_application/data/models/commentData.dart';

import '../../data/models/postData.dart';
import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';

class SpaceState {
  final String newPostContents;
  final String newComment;
  final String newEditContents;
  final List<UserData> spaceUsers;
  final List<UserData> allUsers;
  final FormSubmissionStatus postFormStatus;
  final FormSubmissionStatus inviteUserStatus;
  final FormSubmissionStatus commentFormStatus;
  final FormSubmissionStatus editPostFormStatus;
  final FormSubmissionStatus editCommentFormStatus;
  final FormSubmissionStatus deleteCommentFormStatus;
  final DataRetrievalStatus getPostsStatus;
  final DataRetrievalStatus getMorePostsStatus;
  final DataRetrievalStatus deleteSpaceStatus;
  final DataRetrievalStatus getUsersStatus;
  final DataRetrievalStatus getCommentsStatus;
  final DataRetrievalStatus deletePostStatus;
  final DataRetrievalStatus getNonSpaceUsers;
  final SpaceData currentSpace;
  final UserData currentUser;
  final PostData? selectedPost;

  SpaceState({
    this.newPostContents = '',
    this.newComment = '',
    this.newEditContents = '',
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
    this.getMorePostsStatus = const InitialRetrievalStatus(),
    this.deleteSpaceStatus = const InitialRetrievalStatus(),
    this.getUsersStatus = const InitialRetrievalStatus(),
    this.getCommentsStatus = const InitialRetrievalStatus(),
    this.deletePostStatus = const InitialRetrievalStatus(),
    this.getNonSpaceUsers = const InitialRetrievalStatus(),
    required this.currentSpace,
    required this.currentUser,
  })  : spaceUsers = spaceUsers ?? List<UserData>.empty(),
        allUsers = allUsers ?? List<UserData>.empty();

  SpaceState copyWith({
    String? newPostContents,
    String? newComment,
    String? newEditContents,
    List<UserData>? spaceUsers,
    List<UserData>? nonspaceUsers,
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
    DataRetrievalStatus? getMorePostsStatus,
    DataRetrievalStatus? getCommentsStatus,
    DataRetrievalStatus? deletePostStatus,
    DataRetrievalStatus? getNonSpaceUsersStatus,
    UserData? currentUser,
    SpaceData? currentSpace,
  }) {
    return SpaceState(
      newPostContents: newPostContents ?? this.newPostContents,
      newComment: newComment ?? this.newComment,
      newEditContents: newEditContents ?? this.newEditContents,
      spaceUsers: spaceUsers ?? this.spaceUsers,
      allUsers: nonspaceUsers ?? this.allUsers,
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
      getMorePostsStatus: getMorePostsStatus ?? this.getMorePostsStatus,
      deleteSpaceStatus: deleteSpaceStatus ?? this.deleteSpaceStatus,
      getUsersStatus: getUsersStatus ?? this.getUsersStatus,
      getNonSpaceUsers: getNonSpaceUsersStatus ?? this.getNonSpaceUsers,
      getCommentsStatus: getCommentsStatus ?? this.getCommentsStatus,
      currentSpace: currentSpace ?? this.currentSpace,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
