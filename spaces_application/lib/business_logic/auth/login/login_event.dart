abstract class LoginEvent {}

class LoginEmailChanged extends LoginEvent {
  final String email;

  LoginEmailChanged({required this.email});
}

class ResetEmailChanged extends LoginEvent {
  final String email;

  ResetEmailChanged({required this.email});
}

class PasswordResetSubmit extends LoginEvent {}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({required this.password});
}

class LoginSubmitted extends LoginEvent {}
