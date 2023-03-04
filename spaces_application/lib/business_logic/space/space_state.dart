import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';

import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';

class SpaceState {
  final String newPost;
  final List<UserData> users;
  final FormSubmissionStatus postFormStatus;
  final FormSubmissionStatus inviteUserStatus;
  final DataRetrievalStatus getPostsStatus;
  final DataRetrievalStatus deleteSpaceStatus;
  final DataRetrievalStatus getUsersStatus;
  final SpaceData currentSpace;
  final UserData currentUser;

  SpaceState({
    this.newPost = '',
    List<UserData>? users,
    this.postFormStatus = const InitialFormStatus(),
    this.inviteUserStatus = const InitialFormStatus(),
    this.getPostsStatus = const InitialRetrievalStatus(),
    this.deleteSpaceStatus = const InitialRetrievalStatus(),
    this.getUsersStatus = const InitialRetrievalStatus(),
    required this.currentSpace,
    required this.currentUser,
  }) : users = users ?? List<UserData>.empty();

  SpaceState copyWith({
    String? newPost,
    List<UserData>? users,
    FormSubmissionStatus? postFormStatus,
    FormSubmissionStatus? inviteUserStatus,
    DataRetrievalStatus? deleteSpaceStatus,
    DataRetrievalStatus? getUsersStatus,
    DataRetrievalStatus? getPostsStatus,
    UserData? currentUser,
    SpaceData? currentSpace,
  }) {
    return SpaceState(
      newPost: newPost ?? this.newPost,
      users: users ?? this.users,
      postFormStatus: postFormStatus ?? this.postFormStatus,
      inviteUserStatus: inviteUserStatus ?? this.inviteUserStatus,
      getPostsStatus: getPostsStatus ?? this.getPostsStatus,
      deleteSpaceStatus: deleteSpaceStatus ?? this.deleteSpaceStatus,
      getUsersStatus: getUsersStatus ?? this.getUsersStatus,
      currentSpace: currentSpace ?? this.currentSpace,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
