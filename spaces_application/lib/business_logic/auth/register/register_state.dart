import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:email_validator/email_validator.dart';

class RegisterState {
  final String email;
  bool get isValidEmail => (EmailValidator.validate(email));

  final FormSubmissionStatus formStatus;

  RegisterState({
    this.email = '',
    this.formStatus = const InitialFormStatus(),
  });

  RegisterState copyWith({
    String? email,
    FormSubmissionStatus? formStatus,
  }) {
    return RegisterState(
      email: email ?? this.email,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
