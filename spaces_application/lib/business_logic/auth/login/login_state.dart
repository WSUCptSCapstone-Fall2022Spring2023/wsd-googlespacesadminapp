import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:email_validator/email_validator.dart';

class LoginState {
  final String email;
  bool get isValidEmail => (EmailValidator.validate(email));

  final String password;
  bool get isValidPassword => password.length > 6;

  final FormSubmissionStatus formStatus;

  LoginState({
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
