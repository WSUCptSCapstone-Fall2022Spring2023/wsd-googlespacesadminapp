import 'package:flutter/cupertino.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';
import 'package:spaces_application/data/models/commentData.dart';
import 'package:spaces_application/data/models/permissionData.dart';
import 'package:spaces_application/data/models/userHistoryData.dart';

import '../../data/models/postData.dart';
import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';

class SpaceState {
  final String newPostContents;
  final String newComment;
  final String newEditContents;
  final List<UserHistoryData> userHistory;
  final List<UserData> spaceUsers;
  final List<UserData> allUsers;
  final List<PostData> newPosts;
  final FormSubmissionStatus postFormStatus;
  final FormSubmissionStatus inviteUserStatus;
  final FormSubmissionStatus commentFormStatus;
  final FormSubmissionStatus editPostFormStatus;
  final FormSubmissionStatus editCommentFormStatus;
  final FormSubmissionStatus deleteCommentFormStatus;
  final FormSubmissionStatus updatePermissionsStatus;
  final FormSubmissionStatus kickUserStatus;
  final DataRetrievalStatus getPostsStatus;
  final DataRetrievalStatus getUserHistoryStatus;
  final DataRetrievalStatus getMorePostsStatus;
  final DataRetrievalStatus getNewPostsStatus;
  final DataRetrievalStatus deleteSpaceStatus;
  final DataRetrievalStatus getUsersStatus;
  final DataRetrievalStatus getCommentsStatus;
  final DataRetrievalStatus deletePostStatus;
  final DataRetrievalStatus getNonSpaceUsers;
  final SpaceData currentSpace;
  final UserData currentUser;
  final PostData? selectedPost;
  final PermissionData? permissions;

  SpaceState({
    this.newPostContents = '',
    this.newComment = '',
    this.newEditContents = '',
    this.selectedPost,
    List<UserData>? spaceUsers,
    List<UserData>? allUsers,
    List<PostData>? newPosts,
    List<UserHistoryData>? userHistory,
    this.permissions,
    this.postFormStatus = const InitialFormStatus(),
    this.kickUserStatus = const InitialFormStatus(),
    this.inviteUserStatus = const InitialFormStatus(),
    this.updatePermissionsStatus = const InitialFormStatus(),
    this.commentFormStatus = const InitialFormStatus(),
    this.deleteCommentFormStatus = const InitialFormStatus(),
    this.editCommentFormStatus = const InitialFormStatus(),
    this.editPostFormStatus = const InitialFormStatus(),
    this.getUserHistoryStatus = const InitialRetrievalStatus(),
    this.getPostsStatus = const InitialRetrievalStatus(),
    this.getNewPostsStatus = const InitialRetrievalStatus(),
    this.getMorePostsStatus = const InitialRetrievalStatus(),
    this.deleteSpaceStatus = const InitialRetrievalStatus(),
    this.getUsersStatus = const InitialRetrievalStatus(),
    this.getCommentsStatus = const InitialRetrievalStatus(),
    this.deletePostStatus = const InitialRetrievalStatus(),
    this.getNonSpaceUsers = const InitialRetrievalStatus(),
    required this.currentSpace,
    required this.currentUser,
  })  : spaceUsers = spaceUsers ?? List<UserData>.empty(),
        allUsers = allUsers ?? List<UserData>.empty(),
        newPosts = newPosts ?? List<PostData>.empty(),
        userHistory = userHistory ?? List<UserHistoryData>.empty();

  SpaceState copyWith({
    String? newPostContents,
    String? newComment,
    String? newEditContents,
    List<UserData>? spaceUsers,
    List<UserData>? nonspaceUsers,
    List<PostData>? newPosts,
    List<UserHistoryData>? userHistory,
    PostData? selectedPost,
    FormSubmissionStatus? postFormStatus,
    FormSubmissionStatus? kickUserStatus,
    FormSubmissionStatus? inviteUserStatus,
    FormSubmissionStatus? updatePermissionsStatus,
    FormSubmissionStatus? commentFormStatus,
    FormSubmissionStatus? editCommentFormStatus,
    FormSubmissionStatus? editPostFormStatus,
    FormSubmissionStatus? deleteCommentFormStatus,
    DataRetrievalStatus? getUserHistoryStatus,
    DataRetrievalStatus? deleteSpaceStatus,
    DataRetrievalStatus? getUsersStatus,
    DataRetrievalStatus? getPostsStatus,
    DataRetrievalStatus? getNewPostsStatus,
    DataRetrievalStatus? getMorePostsStatus,
    DataRetrievalStatus? getCommentsStatus,
    DataRetrievalStatus? deletePostStatus,
    DataRetrievalStatus? getNonSpaceUsersStatus,
    UserData? currentUser,
    SpaceData? currentSpace,
    PermissionData? permissions,
  }) {
    return SpaceState(
      permissions: permissions ?? this.permissions,
      newPostContents: newPostContents ?? this.newPostContents,
      kickUserStatus: kickUserStatus ?? this.kickUserStatus,
      newComment: newComment ?? this.newComment,
      newEditContents: newEditContents ?? this.newEditContents,
      userHistory: userHistory ?? this.userHistory,
      spaceUsers: spaceUsers ?? this.spaceUsers,
      allUsers: nonspaceUsers ?? this.allUsers,
      newPosts: newPosts ?? this.newPosts,
      selectedPost: selectedPost ?? this.selectedPost,
      postFormStatus: postFormStatus ?? this.postFormStatus,
      inviteUserStatus: inviteUserStatus ?? this.inviteUserStatus,
      commentFormStatus: commentFormStatus ?? this.commentFormStatus,
      updatePermissionsStatus:
          updatePermissionsStatus ?? this.updatePermissionsStatus,
      editCommentFormStatus:
          editCommentFormStatus ?? this.editCommentFormStatus,
      editPostFormStatus: editPostFormStatus ?? this.editPostFormStatus,
      deleteCommentFormStatus:
          deleteCommentFormStatus ?? this.deleteCommentFormStatus,
      deletePostStatus: deletePostStatus ?? this.deletePostStatus,
      getUserHistoryStatus: getUserHistoryStatus ?? this.getUserHistoryStatus,
      getPostsStatus: getPostsStatus ?? this.getPostsStatus,
      getNewPostsStatus: getNewPostsStatus ?? this.getNewPostsStatus,
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
