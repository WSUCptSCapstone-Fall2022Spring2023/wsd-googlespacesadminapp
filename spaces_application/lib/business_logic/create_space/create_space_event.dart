abstract class CreateSpaceEvent {}

class CreateSpaceNameChanged extends CreateSpaceEvent {
  final String name;

  CreateSpaceNameChanged({required this.name});
}

class CreateSpaceDescriptionChanged extends CreateSpaceEvent {
  final String description;

  CreateSpaceDescriptionChanged({required this.description});
}

class CreateSpaceIsPrivateChanged extends CreateSpaceEvent {
  bool? isPrivate;

  CreateSpaceIsPrivateChanged({required this.isPrivate});
}

// class CreateSpacePictureChanged extends CreateSpaceEvent {
//   final File photo;

//   CreateSpacePictureChanged({required this.photo});
// }

class CreateSpaceSubmitted extends CreateSpaceEvent {}
