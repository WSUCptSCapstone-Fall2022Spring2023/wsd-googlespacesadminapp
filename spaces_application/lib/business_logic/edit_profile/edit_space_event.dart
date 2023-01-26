abstract class EditProfileEvent {}

class ProfileFirstNameChanged extends EditProfileEvent {
  final String firstName;

  ProfileFirstNameChanged({required this.firstName});
}

class ProfileLastNameChanged extends EditProfileEvent {
  final String lastName;

  ProfileLastNameChanged({required this.lastName});
}

class ProfileDisplayNameChanged extends EditProfileEvent {
  final String displayName;

  ProfileDisplayNameChanged({required this.displayName});
}

class ProfileSubmitted extends EditProfileEvent {}
