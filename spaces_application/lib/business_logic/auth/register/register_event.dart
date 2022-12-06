abstract class RegisterEvent {}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  RegisterEmailChanged({required this.email});
}

class RegisterParentEmailChanged extends RegisterEvent {
  final String parentEmail;

  RegisterParentEmailChanged({required this.parentEmail});
}

class RegisterFirstNameChanged extends RegisterEvent {
  final String firstName;

  RegisterFirstNameChanged({required this.firstName});
}

class RegisterLastNameChanged extends RegisterEvent {
  final String lastName;

  RegisterLastNameChanged({required this.lastName});
}

class RegisterSubmitted extends RegisterEvent {}
