import 'package:spaces_application/business_logic/auth/form_submission_status.dart';

import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';

class SpaceState {
  final String newPost;
  final FormSubmissionStatus formStatus;
  SpaceData? currentSpace;

  SpaceState({
    this.newPost = '',
    this.formStatus = const InitialFormStatus(),
    this.currentSpace,
  });

  SpaceState copyWith({
    String? newPost,
    FormSubmissionStatus? formStatus,
    UserData? currentUser,
    SpaceData? currentSpace,
  }) {
    return SpaceState(
      newPost: newPost ?? this.newPost,
      formStatus: formStatus ?? this.formStatus,
      currentSpace: currentSpace ?? this.currentSpace,
    );
  }
}
