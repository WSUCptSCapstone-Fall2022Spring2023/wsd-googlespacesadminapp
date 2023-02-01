import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:email_validator/email_validator.dart';

import '../../../data/models/userData.dart';

class LoginState {
  final String email;
  bool get isValidEmail => (EmailValidator.validate(email));

  final String password;
  bool get isValidPassword => password.length > 6;

  final FormSubmissionStatus formStatus;

  UserData? currentUser;

  LoginState({
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
    this.currentUser,
  });

  LoginState copyWith({
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
    UserData? currentUser,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
