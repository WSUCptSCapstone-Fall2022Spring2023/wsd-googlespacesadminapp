import 'package:spaces_application/business_logic/auth/form_submission_status.dart';

import '../../data/models/userData.dart';

class CreateSpaceState {
  final String name;
  bool get isValidName => name.length > 5;
  final String description;
  bool isPrivate = false;

  //final File photo;

  final FormSubmissionStatus formStatus;

  UserData? currentUser;

  CreateSpaceState({
    this.name = '',
    this.description = '',
    this.isPrivate = false,
    this.formStatus = const InitialFormStatus(),
    this.currentUser,
  });

  CreateSpaceState copyWith({
    String? name,
    String? description,
    bool? isPrivate,
    FormSubmissionStatus? formStatus,
    UserData? currentUser,
  }) {
    return CreateSpaceState(
      name: name ?? this.name,
      description: description ?? this.description,
      isPrivate: isPrivate ?? this.isPrivate,
      formStatus: formStatus ?? this.formStatus,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
