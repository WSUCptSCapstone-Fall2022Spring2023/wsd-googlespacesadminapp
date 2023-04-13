import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';
import 'package:spaces_application/data/models/spaceData.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/data/repositories/space_repository.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';
import 'nav_event.dart';
import 'nav_state.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  final UserDataRepository userRepo;
  final SpaceRepository spaceRepo;
  final UserData currentUserData;

  NavBarBloc(
      {required this.userRepo,
      required this.spaceRepo,
      required this.currentUserData})
      : super(NavBarState(currentUserData: currentUserData)) {
    on<GetUnjoinedSpaces>((event, emit) async {
      await _onGetUnjoinedSpaces(emit);
    });
    on<JoinSpace>((event, emit) async {
      await _onJoinSpace(event.selectedSpace, emit);
    });
  }

  Future<void> _onGetUnjoinedSpaces(Emitter<NavBarState> emit) async {
    emit(state.copyWith(spaceRetrievalStatus: DataRetrieving()));
    try {
      final unjoinedSpaces = await spaceRepo.getAllSpaces();
      for (final space in state.currentUserData.spacesJoined) {
        unjoinedSpaces.removeWhere((element) => element.sid == space.sid);
      }
      if (state.currentUserData.isFaculty == false) {
        unjoinedSpaces.removeWhere((element) => element.isPrivate == true);
      }
      emit(state.copyWith(
          spaceRetrievalStatus: RetrievalSuccess(),
          unjoinedSpaces: unjoinedSpaces));
    } catch (e) {
      emit(state.copyWith(spaceRetrievalStatus: RetrievalFailed(Exception(e))));
    }
  }

  Future<void> _onJoinSpace(
      SpaceData selectedSpace, Emitter<NavBarState> emit) async {
    emit(state.copyWith(joinSpaceStatus: FormSubmitting()));
    try {
      List<UserData> users = List<UserData>.filled(1, state.currentUserData);
      await spaceRepo.joinSpace(selectedSpace.sid, users);
      final replaceCurrentUserData = await userRepo.getCurrentUserData();
      emit(state.copyWith(
          joinSpaceStatus: SubmissionSuccess(),
          currentUserData: replaceCurrentUserData));
    } catch (e) {
      emit(state.copyWith(joinSpaceStatus: SubmissionFailed(Exception(e))));
    }
  }
}
