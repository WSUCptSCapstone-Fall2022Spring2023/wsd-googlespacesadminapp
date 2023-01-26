import 'package:spaces_application/business_logic/auth/form_submission_status.dart';

class EditProfileState {
  final String firstName;
  bool get isValidFirstName => firstName.length > 1 && firstName.length < 21;
  final String lastName;
  bool get isValidLastName => lastName.length > 1 && lastName.length < 21;
  final String displayName;
  bool get isValidDisplayName =>
      displayName.length > 1 && displayName.length < 26;

  final FormSubmissionStatus formStatus;

  EditProfileState({
    this.firstName = '',
    this.lastName = '',
    this.displayName = '',
    this.formStatus = const InitialFormStatus(),
  });

  EditProfileState copyWith({
    String? firstName,
    String? lastName,
    String? displayName,
    FormSubmissionStatus? formStatus,
  }) {
    return EditProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
