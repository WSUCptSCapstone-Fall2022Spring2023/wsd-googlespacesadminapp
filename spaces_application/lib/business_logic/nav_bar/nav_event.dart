import 'package:spaces_application/data/models/spaceData.dart';
import 'package:spaces_application/data/models/userData.dart';

abstract class NavBarEvent {}

// gets the public spaces if student and public/private spaces if faculty
class GetUnjoinedSpaces extends NavBarEvent {}

class JoinSpace extends NavBarEvent {
  SpaceData selectedSpace;

  JoinSpace({required this.selectedSpace});
}
