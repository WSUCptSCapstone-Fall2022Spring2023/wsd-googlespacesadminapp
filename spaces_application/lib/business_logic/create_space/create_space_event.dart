abstract class CreateSpaceEvent {}

class CreateSpaceNameChanged extends CreateSpaceEvent {
  final String name;

  CreateSpaceNameChanged({required this.name});
}

class CreateSpaceSubmitted extends CreateSpaceEvent {}
