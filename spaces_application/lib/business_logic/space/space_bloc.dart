import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';
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
  final SpaceData currentSpaceData;

  SpaceBloc(
      {required this.spaceRepo,
      required this.userRepo,
      required this.currentUserData,
      required this.currentSpaceData})
      : super(SpaceState(
            currentSpace: currentSpaceData, currentUser: currentUserData)) {
    on<PostMessageChanged>((event, emit) async {
      await _onMessageChanged(event.message, emit);
    });
    on<LoadPosts>((event, emit) async {
      await _onLoadSpacePosts(emit);
    });
    on<PostSubmitted>((event, emit) async {
      await _onFormStatusChanged(emit);
    });
    on<DeleteSpace>((event, emit) async {
      await _onDeleteSpace(emit);
    });
    on<GetUsers>((event, emit) async {
      await _onGetUsers(emit);
    });
    on<InviteUser>((event, emit) async {
      await _inviteUser(event.invitedUser, emit);
    });
  }

  Future<void> _onMessageChanged(
      String newPost, Emitter<SpaceState> emit) async {
    emit(state.copyWith(newPost: newPost));
  }

  Future<void> _onLoadSpacePosts(Emitter<SpaceState> emit) async {
    emit(state.copyWith(getPostsStatus: DataRetrieving()));
    try {
      final posts = await spaceRepo.getSpacePosts(state.currentSpace.sid);
      final replaceSpace = state.currentSpace;
      replaceSpace.spacePosts = posts;
      emit(state.copyWith(
          currentSpace: replaceSpace, getPostsStatus: RetrievalSuccess()));
    } catch (e) {
      emit(state.copyWith(getPostsStatus: RetrievalFailed(Exception(e))));
    }
  }

  // Future<void> _onIsPrivateChanged(
  //     bool newIsPrivate, Emitter<CreateSpaceState> emit) async {
  //   emit(state.copyWith(isPrivate: newIsPrivate));
  // }

  Future<void> _onFormStatusChanged(Emitter<SpaceState> emit) async {
    emit(state.copyWith(postFormStatus: FormSubmitting()));
    try {
      await spaceRepo.createPost(
          state.newPost, currentUserData.uid, state.currentSpace.sid);
      emit(state.copyWith(postFormStatus: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(postFormStatus: SubmissionFailed(Exception(e))));
    }
  }

  Future<void> _onDeleteSpace(Emitter<SpaceState> emit) async {
    emit(state.copyWith(deleteSpaceStatus: DataRetrieving()));
    try {
      await spaceRepo.deleteSpace(state.currentSpace.sid);
      emit(state.copyWith(deleteSpaceStatus: RetrievalSuccess()));
    } catch (e) {
      emit(state.copyWith(deleteSpaceStatus: RetrievalFailed(Exception(e))));
    }
  }

  Future<void> _onGetUsers(Emitter<SpaceState> emit) async {
    emit(state.copyWith(getUsersStatus: DataRetrieving()));
    try {
      final List<UserData> users =
          await spaceRepo.getUsersInSpace(state.currentSpace);
      emit(state.copyWith(getUsersStatus: RetrievalSuccess(), users: users));
    } catch (e) {
      emit(state.copyWith(getUsersStatus: RetrievalFailed(Exception(e))));
    }
  }

  Future<void> _inviteUser(
      UserData invitedUser, Emitter<SpaceState> emit) async {
    emit(state.copyWith(inviteUserStatus: FormSubmitting()));
    try {
      await spaceRepo.joinSpace(
          state.currentSpace.sid, invitedUser.uid, invitedUser.isFaculty);
      emit(state.copyWith(inviteUserStatus: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(inviteUserStatus: SubmissionFailed(Exception(e))));
    }
  }
}

  // async* allows us to yield values out the Stream


