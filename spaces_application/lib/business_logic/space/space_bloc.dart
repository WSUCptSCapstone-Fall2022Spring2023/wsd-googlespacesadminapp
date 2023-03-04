import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/space/space_event.dart';
import 'package:spaces_application/business_logic/space/space_state.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/data/repositories/space_repository.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';

import '../../data/models/spaceData.dart';

class SpaceBloc extends Bloc<SpaceEvent, SpaceState> {
  final SpaceRepository spaceRepo;
  final UserDataRepository userRepo;
  final UserData currentUserData;

  SpaceBloc(
      {required this.spaceRepo,
      required this.userRepo,
      required this.currentUserData})
      : super(SpaceState()) {
    on<PostMessageChanged>((event, emit) async {
      await _onMessageChanged(event.message, emit);
    });
    on<LoadCurrentSpace>((event, emit) async {
      await _onLoadSpacePosts(event.currentSpace, emit);
    });
    on<PostSubmitted>((event, emit) async {
      await _onFormStatusChanged(emit);
    });
  }

  Future<void> _onMessageChanged(
      String newPost, Emitter<SpaceState> emit) async {
    emit(state.copyWith(newPost: newPost));
  }

  Future<void> _onLoadSpacePosts(
      SpaceData newSpace, Emitter<SpaceState> emit) async {
    try {
      final posts = await spaceRepo.getSpacePosts(newSpace.sid);
      newSpace.spacePosts = posts;
      emit(state.copyWith(currentSpace: newSpace));
    } catch (e) {
      throw Exception(e);
    }
  }

  // Future<void> _onIsPrivateChanged(
  //     bool newIsPrivate, Emitter<CreateSpaceState> emit) async {
  //   emit(state.copyWith(isPrivate: newIsPrivate));
  // }

  Future<void> _onFormStatusChanged(Emitter<SpaceState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    try {
      await spaceRepo.createPost(
          state.newPost, currentUserData.uid, state.currentSpace!.sid);
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(Exception(e))));
    }
  }
}

  // async* allows us to yield values out the Stream


