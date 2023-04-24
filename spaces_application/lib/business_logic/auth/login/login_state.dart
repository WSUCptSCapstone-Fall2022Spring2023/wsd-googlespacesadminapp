import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:email_validator/email_validator.dart';

import '../../../data/models/userData.dart';

class LoginState {
  final String email;
  bool get isValidEmail => (EmailValidator.validate(email));

  final String resetEmail;
  bool get isValidResetEmail => (EmailValidator.validate(resetEmail));

  final String password;
  bool get isValidPassword => password.length > 6;

  final FormSubmissionStatus formStatus;
  final FormSubmissionStatus resetStatus;

  UserData? currentUser;

  LoginState({
    this.email = '',
    this.resetEmail = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
    this.resetStatus = const InitialFormStatus(),
    this.currentUser,
  });

  LoginState copyWith({
    String? email,
    String? resetEmail,
    String? password,
    FormSubmissionStatus? formStatus,
    FormSubmissionStatus? resetStatus,
    UserData? currentUser,
  }) {
    return LoginState(
      email: email ?? this.email,
      resetEmail: resetEmail ?? this.resetEmail,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      resetStatus: resetStatus ?? this.resetStatus,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
