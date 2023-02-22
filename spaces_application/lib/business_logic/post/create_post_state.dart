import 'package:spaces_application/business_logic/auth/form_submission_status.dart';

import '../../data/models/userData.dart';

class CreatePostState {
  final String message;
  final String userID;
  final String spaceID;
  final FormSubmissionStatus formStatus;
  UserData? currentUser;

  CreatePostState(
      {this.message = '',
      this.userID = '',
      this.spaceID = '',
      this.formStatus = const InitialFormStatus(),
      this.currentUser});

  CreatePostState copyWith({
    String? message,
    String? userID,
    String? spaceID,
    FormSubmissionStatus? formStatus,
    UserData? currentUser,
  }) {
    return CreatePostState(
      message: message ?? this.message,
      userID: userID ?? this.userID,
      spaceID: spaceID ?? this.spaceID,
      formStatus: formStatus ?? this.formStatus,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
