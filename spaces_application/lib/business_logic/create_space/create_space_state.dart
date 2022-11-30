import 'package:spaces_application/business_logic/auth/form_submission_status.dart';

class CreateSpaceState {
  final String name;
  bool get isValidName => name.length > 3;

  final FormSubmissionStatus formStatus;

  CreateSpaceState({
    this.name = '',
    this.formStatus = const InitialFormStatus(),
  });

  CreateSpaceState copyWith({
    String? name,
    FormSubmissionStatus? formStatus,
  }) {
    return CreateSpaceState(
      name: name ?? this.name,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
