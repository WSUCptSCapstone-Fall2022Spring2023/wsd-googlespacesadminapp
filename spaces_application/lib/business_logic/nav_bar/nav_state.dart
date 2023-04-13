import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';
import 'package:spaces_application/business_logic/space/space_bloc.dart';
import 'package:spaces_application/data/models/spaceData.dart';

import '../../data/models/userData.dart';

class NavBarState {
  final DataRetrievalStatus spaceRetrievalStatus;
  final FormSubmissionStatus joinSpaceStatus;
  final UserData currentUserData;
  final List<SpaceData> publicSpaces;

  NavBarState({
    this.spaceRetrievalStatus = const InitialRetrievalStatus(),
    this.joinSpaceStatus = const InitialFormStatus(),
    List<SpaceData>? publicSpaces,
    required this.currentUserData,
  }) : publicSpaces = publicSpaces ?? List<SpaceData>.empty();

  NavBarState copyWith(
      {UserData? currentUserData,
      DataRetrievalStatus? spaceRetrievalStatus,
      FormSubmissionStatus? joinSpaceStatus,
      List<SpaceData>? unjoinedSpaces}) {
    return NavBarState(
      currentUserData: currentUserData ?? this.currentUserData,
      joinSpaceStatus: joinSpaceStatus ?? this.joinSpaceStatus,
      publicSpaces: unjoinedSpaces ?? this.publicSpaces,
      spaceRetrievalStatus: spaceRetrievalStatus ?? this.spaceRetrievalStatus,
    );
  }
}
