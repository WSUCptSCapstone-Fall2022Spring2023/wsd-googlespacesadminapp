import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';
import 'package:spaces_application/business_logic/space/space_event.dart';
import 'package:spaces_application/business_logic/space/space_state.dart';
import 'package:spaces_application/data/models/userData.dart';
import 'package:spaces_application/data/repositories/space_repository.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';

import '../../data/models/commentData.dart';
import '../../data/models/postData.dart';
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
    on<LoadSpacePosts>((event, emit) async {
      await _onLoadSpacePosts(emit);
    });
    on<PostSubmitted>((event, emit) async {
      await _submitPost(emit);
    });
    on<DeleteSpace>((event, emit) async {
      await _onDeleteSpace(emit);
    });
    on<GetSpaceUsers>((event, emit) async {
      await _onGetSpaceUsers(emit);
    });
    on<InviteUsers>((event, emit) async {
      await _inviteUsers(event.invitedUsers, emit);
    });
    on<LoadPostComments>((event, emit) async {
      await _onLoadPostComments(event.selectedPost, emit);
    });
    on<CommentMessageChanged>((event, emit) async {
      await _onCommentChanged(event.message, emit);
    });
    on<CommentSubmitted>((event, emit) async {
      await _submitComment(emit);
    });
    on<RemovePost>((event, emit) async {
      await _onRemovePost(emit, event.selectedPost);
    });
    on<GetAllUsers>((event, emit) async {
      await _onGetAllUsers(emit);
    });
  }

  Future<void> _onMessageChanged(
      String newPost, Emitter<SpaceState> emit) async {
    emit(state.copyWith(newPost: newPost));
  }

  Future<void> _onCommentChanged(
      String newComment, Emitter<SpaceState> emit) async {
    emit(state.copyWith(newComment: newComment));
  }

  Future<void> _onLoadSpacePosts(Emitter<SpaceState> emit) async {
    emit(state.copyWith(getPostsStatus: DataRetrieving()));
    try {
      final posts = await spaceRepo.getSpacePosts(state.currentSpace.sid);

      // final DatabaseReference spaceRef =
      //     await spaceRepo.getSpaceReference(state.currentSpace.sid);
      // spaceRef.onChildAdded.listen((event) {
      //   final post = event.snapshot.value;
      //   final replaceSpace = state.currentSpace;
      //   replaceSpace.spacePosts.add(post);
      //   emit(state.copyWith(
      //       currentSpace: replaceSpace, getPostsStatus: RetrievalSuccess()));
      // });
      final replaceSpace = state.currentSpace;
      replaceSpace.spacePosts = posts;
      emit(state.copyWith(
          currentSpace: replaceSpace, getPostsStatus: RetrievalSuccess()));
    } catch (e) {
      emit(state.copyWith(getPostsStatus: RetrievalFailed(Exception(e))));
    }
  }

  Future<void> _onLoadPostComments(
      PostData selectedPost, Emitter<SpaceState> emit) async {
    emit(state.copyWith(getCommentsStatus: DataRetrieving()));
    try {
      final comments = await spaceRepo.getPostComments(
          selectedPost.postUser.uid, selectedPost.postedTime);
      selectedPost.comments = comments;
      emit(state.copyWith(
          selectedPost: selectedPost, getCommentsStatus: RetrievalSuccess()));
    } catch (e) {
      emit(state.copyWith(getCommentsStatus: RetrievalFailed(Exception(e))));
    }
  }

  // Future<void> _onIsPrivateChanged(
  //     bool newIsPrivate, Emitter<CreateSpaceState> emit) async {
  //   emit(state.copyWith(isPrivate: newIsPrivate));
  // }

  Future<void> _submitPost(Emitter<SpaceState> emit) async {
    emit(state.copyWith(postFormStatus: FormSubmitting()));
    try {
      final currentTime = DateTime.now();
      await spaceRepo.createPost(state.newPost, currentUserData.uid,
          state.currentSpace.sid, currentTime);
      final replaceSpace = state.currentSpace;
      final newPost = PostData(state.newPost, currentUserData, currentTime, 0);
      replaceSpace.spacePosts.add(newPost);
      emit(state.copyWith(
          currentSpace: replaceSpace, postFormStatus: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(postFormStatus: SubmissionFailed(Exception(e))));
    }
  }

  Future<void> _submitComment(Emitter<SpaceState> emit) async {
    emit(state.copyWith(commentFormStatus: FormSubmitting()));
    try {
      DateTime currentTime = DateTime.now();
      await spaceRepo.createComment(
          state.newComment,
          state.selectedPost!.postUser.uid,
          currentUserData.uid,
          state.currentSpace.sid,
          state.selectedPost!.postedTime,
          currentTime);
      final newComment =
          CommentData(state.newComment, currentUserData, currentTime);
      final replacePost = state.selectedPost!;
      replacePost.comments.add(newComment);
      emit(state.copyWith(
          selectedPost: replacePost, commentFormStatus: SubmissionSuccess()));
      emit(state.copyWith(commentFormStatus: const InitialFormStatus()));
    } catch (e) {
      emit(state.copyWith(commentFormStatus: SubmissionFailed(Exception(e))));
      emit(state.copyWith(commentFormStatus: const InitialFormStatus()));
    }
  }

  Future<void> _onRemovePost(
      Emitter<SpaceState> emit, PostData selectedPost) async {
    emit(state.copyWith(deletePostStatus: DataRetrieving()));
    try {
      await spaceRepo.deletePost(selectedPost.postedTime,
          state.currentSpace.sid, selectedPost.postUser.uid);
      final replaceSpace = state.currentSpace;
      replaceSpace.spacePosts.removeWhere(
        (element) => element.postedTime == selectedPost.postedTime,
      );
      emit(state.copyWith(
          deletePostStatus: RetrievalSuccess(), currentSpace: replaceSpace));
    } catch (e) {
      emit(state.copyWith(deletePostStatus: RetrievalFailed(Exception(e))));
    }
  }

  Future<void> _onDeleteSpace(Emitter<SpaceState> emit) async {
    emit(state.copyWith(deleteSpaceStatus: DataRetrieving()));
    try {
      await spaceRepo.deleteSpace(state.currentSpace.sid);
      UserData currentUser = await userRepo.getCurrentUserData();
      emit(state.copyWith(
          deleteSpaceStatus: RetrievalSuccess(), currentUser: currentUser));
    } catch (e) {
      emit(state.copyWith(deleteSpaceStatus: RetrievalFailed(Exception(e))));
    }
  }

  Future<void> _onGetSpaceUsers(Emitter<SpaceState> emit) async {
    emit(state.copyWith(getUsersStatus: DataRetrieving()));
    try {
      final List<UserData> users =
          await spaceRepo.getUsersInSpace(state.currentSpace.sid);
      emit(state.copyWith(
          getUsersStatus: RetrievalSuccess(), spaceUsers: users));
    } catch (e) {
      emit(state.copyWith(getUsersStatus: RetrievalFailed(Exception(e))));
    }
  }

  Future<void> _onGetAllUsers(Emitter<SpaceState> emit) async {
    emit(state.copyWith(getAllUsersStatus: DataRetrieving()));
    try {
      final List<UserData> users = await userRepo.getAllUsers();
      emit(state.copyWith(
          getAllUsersStatus: RetrievalSuccess(), allUsers: users));
    } catch (e) {
      emit(state.copyWith(getAllUsersStatus: RetrievalFailed(Exception(e))));
    }
  }

  Future<void> _inviteUsers(
      List<UserData> invitedUsers, Emitter<SpaceState> emit) async {
    emit(state.copyWith(inviteUserStatus: FormSubmitting()));
    try {
      await spaceRepo.joinSpace(state.currentSpace.sid, invitedUsers);
      emit(state.copyWith(
          inviteUserStatus: SubmissionSuccess(),
          getUsersStatus: const InitialRetrievalStatus()));
    } catch (e) {
      emit(state.copyWith(inviteUserStatus: SubmissionFailed(Exception(e))));
    }
  }
}

  // async* allows us to yield values out the Stream


