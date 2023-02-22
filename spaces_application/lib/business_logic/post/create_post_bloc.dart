import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/post/create_post_event.dart';
import 'package:spaces_application/business_logic/post/create_post_state.dart';
import 'package:spaces_application/data/repositories/space_repository.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final SpaceRepository spaceRepo;
  final UserDataRepository userRepo;

  CreatePostBloc({required this.spaceRepo, required this.userRepo})
      : super(CreatePostState()) {
    on<PostMessageChanged>((event, emit) async {
      await _onMessageChanged(event.message, emit);
    });
    on<PostUserIDChanged>((event, emit) async {
      await _onUserIDChanged(event.userID, emit);
    });
    on<PostSpaceIDChanged>((event, emit) async {
      await _onSpaceIDChanged(event.spaceID, emit);
    });
    // on<CreateSpaceIsPrivateChanged>((event, emit) async {
    //   await _onIsPrivateChanged(event.isPrivate, emit);
    // });
    on<CreatePostSubmitted>((event, emit) async {
      await _onFormStatusChanged(emit);
    });
  }

  Future<void> _onMessageChanged(
      String newMessage, Emitter<CreatePostState> emit) async {
    emit(state.copyWith(message: newMessage));
  }

  Future<void> _onUserIDChanged(
      String newUserID, Emitter<CreatePostState> emit) async {
    emit(state.copyWith(userID: newUserID));
  }

  Future<void> _onSpaceIDChanged(
      String newSpaceID, Emitter<CreatePostState> emit) async {
    emit(state.copyWith(spaceID: newSpaceID));
  }

  // Future<void> _onIsPrivateChanged(
  //     bool newIsPrivate, Emitter<CreateSpaceState> emit) async {
  //   emit(state.copyWith(isPrivate: newIsPrivate));
  // }

  Future<void> _onFormStatusChanged(Emitter<CreatePostState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    try {
      await spaceRepo.createPost(state.message, state.userID, state.spaceID);
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(Exception(e))));
    }
  }
}

  // async* allows us to yield values out the Stream


