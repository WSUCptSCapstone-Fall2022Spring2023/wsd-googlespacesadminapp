import 'package:spaces_application/business_logic/auth/form_submission_status.dart';

import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';

class PostState {
  final String message;
  final FormSubmissionStatus formStatus;
  SpaceData? currentSpace;

  PostState({
    this.message = '',
    this.formStatus = const InitialFormStatus(),
    this.currentSpace,
  });

  PostState copyWith({
    String? message,
    FormSubmissionStatus? formStatus,
    UserData? currentUser,
    SpaceData? currentSpace,
  }) {
    return PostState(
      message: message ?? this.message,
      formStatus: formStatus ?? this.formStatus,
      currentSpace: currentSpace ?? this.currentSpace,
    );
  }
}
