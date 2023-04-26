import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
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
            currentSpace: currentSpaceData,
            currentUser: currentUserData,
            permissions: currentUserData.spacesPermissions.singleWhere(
                (element) => element.spaceID == currentSpaceData.sid))) {
    on<PostMessageChanged>((event, emit) async {
      await _onMessageChanged(event.message, emit);
    });
    on<EditFieldChanged>((event, emit) async {
      await _onEditFieldChanged(event.message, emit);
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
    on<LoadMoreSpacePosts>((event, emit) async {
      await _onLoadMoreSpacePosts(emit);
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
    on<GetNonSpaceUsers>((event, emit) async {
      await _onGetNonSpaceUsers(emit);
    });
    on<RemoveComment>((event, emit) async {
      await _onRemoveComment(emit, event.selectedComment);
    });
    on<EditComment>((event, emit) async {
      await _onEditComment(emit, event.newContents, event.selectedComment);
    });
    on<EditPost>((event, emit) async {
      await _onEditPost(emit, event.newContents, event.selectedPost);
    });
    on<UpdatePermissions>((event, emit) async {
      await _onUpdatePermissions(emit, event.selectedUserID, event.canComment,
          event.canEdit, event.canInvite, event.canPost, event.canRemove);
    });
    on<KickUser>((event, emit) async {
      await _onKickUser(emit, event.uid);
    });
    on<ChangePrivacy>((event, emit) async {
      await _onChangePrivacy(emit);
    });
    on<GetNewPosts>((event, emit) async {
      await _getNewPosts(emit, event.lastPostTime);
    });
    on<GetUserHistory>((event, emit) async {
      await _getUserHistory(emit, event.displayName, event.email, event.uid,
          event.month, event.year);
    });
  }

  Future<void> _onMessageChanged(
      String newPost, Emitter<SpaceState> emit) async {
    emit(state.copyWith(newPostContents: newPost));
  }

  Future<void> _onCommentChanged(
      String newComment, Emitter<SpaceState> emit) async {
    emit(state.copyWith(newComment: newComment));
  }

  Future<void> _onEditFieldChanged(
      String newEditContents, Emitter<SpaceState> emit) async {
    emit(state.copyWith(newEditContents: newEditContents));
  }

  Future<void> _onLoadSpacePosts(Emitter<SpaceState> emit) async {
    emit(state.copyWith(getPostsStatus: DataRetrieving()));
    try {
      final posts = await spaceRepo.getSpacePosts(state.currentSpace.sid);
      final permissions = await spaceRepo.getPermissions(
          state.currentUser.uid, state.currentSpace.sid);
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
          currentSpace: replaceSpace,
          getPostsStatus: RetrievalSuccess(),
          permissions: permissions));
    } catch (e) {
      emit(state.copyWith(getPostsStatus: RetrievalFailed(Exception(e))));
    }
  }

  Future<void> _onLoadMoreSpacePosts(Emitter<SpaceState> emit) async {
    emit(state.copyWith(getMorePostsStatus: DataRetrieving()));
    try {
      final posts = await spaceRepo.getMoreSpacePosts(state.currentSpace.sid,
          state.currentSpace.spacePosts.first.postedTime);
      final replaceSpace = state.currentSpace;
      replaceSpace.spacePosts.insertAll(0, posts);
      emit(state.copyWith(
          currentSpace: replaceSpace, getMorePostsStatus: RetrievalSuccess()));
    } catch (e) {
      emit(state.copyWith(getMorePostsStatus: RetrievalFailed(Exception(e))));
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
      await spaceRepo.createPost(state.newPostContents, currentUserData.uid,
          state.currentSpace.sid, currentTime);
      final replaceSpace = state.currentSpace;
      final newPost =
          PostData(state.newPostContents, currentUserData, currentTime, 0);
      replaceSpace.spacePosts.add(newPost);
      emit(state.copyWith(
          currentSpace: replaceSpace,
          postFormStatus: SubmissionSuccess(),
          newPostContents: ""));
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
      emit(state.copyWith(
          commentFormStatus: SubmissionFailed(Exception(e)), newComment: ""));
      emit(state.copyWith(commentFormStatus: const InitialFormStatus()));
    }
  }

  Future<void> _onRemovePost(
      Emitter<SpaceState> emit, PostData selectedPost) async {
    emit(state.copyWith(deletePostStatus: DataRetrieving()));
    try {
      await spaceRepo.deletePost(state.currentUser.uid, selectedPost.postedTime,
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

  Future<void> _onGetNonSpaceUsers(Emitter<SpaceState> emit) async {
    emit(state.copyWith(getNonSpaceUsersStatus: DataRetrieving()));
    try {
      final List<UserData> users = await userRepo.getAllUsers();
      if (state.spaceUsers.isEmpty) {
        await _onGetSpaceUsers(emit);
      }
      for (final index in state.spaceUsers) {
        users.removeWhere(
          (element) => index.uid == element.uid,
        );
      }
      emit(state.copyWith(
          getNonSpaceUsersStatus: RetrievalSuccess(), nonspaceUsers: users));
    } catch (e) {
      emit(state.copyWith(
          getNonSpaceUsersStatus: RetrievalFailed(Exception(e))));
    }
  }

  Future<void> _inviteUsers(
      List<UserData> invitedUsers, Emitter<SpaceState> emit) async {
    emit(state.copyWith(inviteUserStatus: FormSubmitting()));
    try {
      await spaceRepo.joinSpace(state.currentSpace.sid, invitedUsers);
      emit(state.copyWith(
          inviteUserStatus: SubmissionSuccess(),
          getUsersStatus: const InitialRetrievalStatus(),
          getNonSpaceUsersStatus: const InitialRetrievalStatus()));
    } catch (e) {
      emit(state.copyWith(inviteUserStatus: SubmissionFailed(Exception(e))));
    }
  }

  Future<void> _onRemoveComment(
      Emitter<SpaceState> emit, CommentData selectedComment) async {
    emit(state.copyWith(deleteCommentFormStatus: FormSubmitting()));
    try {
      await spaceRepo.deleteComment(
          state.currentUser.uid,
          state.currentSpace.sid,
          selectedComment.commentedTime,
          state.selectedPost!.postedTime,
          state.selectedPost!.postUser.uid);
      final replaceSpace = state.currentSpace;
      final replacePost = state.selectedPost;
      replacePost!.comments.removeWhere(
        (element) => element.commentedTime == selectedComment.commentedTime,
      );
      final index = replaceSpace.spacePosts.indexWhere(
        (element) => element.postedTime == replacePost.postedTime,
      );
      replaceSpace.spacePosts[index] = replacePost;
      emit(state.copyWith(
          deleteCommentFormStatus: SubmissionSuccess(),
          currentSpace: replaceSpace,
          selectedPost: replacePost));
    } catch (e) {
      emit(state.copyWith(
          deleteCommentFormStatus: SubmissionFailed(Exception(e))));
    }
  }

  Future<void> _onChangePrivacy(Emitter<SpaceState> emit) async {
    await spaceRepo.changePrivacy(
        state.currentSpace.sid, !(state.currentSpace.isPrivate));
    final replaceSpace = state.currentSpace;
    replaceSpace.isPrivate = !(state.currentSpace.isPrivate);
    emit(state.copyWith(currentSpace: replaceSpace));
  }

  Future<void> _onEditPost(Emitter<SpaceState> emit, String newContents,
      PostData selectedPost) async {
    emit(state.copyWith(editPostFormStatus: FormSubmitting()));
    try {
      await spaceRepo.editPost(state.currentUser.uid, selectedPost.postedTime,
          newContents, currentSpaceData.sid);
      final replaceSpace = state.currentSpace;
      final index = replaceSpace.spacePosts.indexWhere(
        (element) => element.postedTime == selectedPost.postedTime,
      );
      replaceSpace.spacePosts[index].contents = newContents;
      emit(state.copyWith(
          editPostFormStatus: SubmissionSuccess(), currentSpace: replaceSpace));
    } catch (e) {
      emit(state.copyWith(editPostFormStatus: SubmissionFailed(Exception(e))));
    }
  }

  Future<void> _onEditComment(Emitter<SpaceState> emit, String newContents,
      CommentData selectedComment) async {
    emit(state.copyWith(editCommentFormStatus: FormSubmitting()));
    try {
      await spaceRepo.editComment(
          state.currentUser.uid,
          state.currentSpace.sid,
          selectedComment.commentedTime,
          state.selectedPost!.postedTime,
          newContents,
          state.selectedPost!.postUser.uid);
      final replaceSpace = state.currentSpace;
      final replacePost = state.selectedPost;
      final commentIndex = replacePost!.comments.indexWhere(
        (element) => element.commentedTime == selectedComment.commentedTime,
      );
      replacePost.comments[commentIndex].contents = newContents;
      final postIndex = replaceSpace.spacePosts.indexWhere(
        (element) => element.postedTime == replacePost.postedTime,
      );
      replaceSpace.spacePosts[postIndex] = replacePost;
      emit(state.copyWith(
          editCommentFormStatus: SubmissionSuccess(),
          currentSpace: replaceSpace,
          selectedPost: replacePost));
    } catch (e) {
      emit(state.copyWith(
          editCommentFormStatus: SubmissionFailed(Exception(e))));
    }
  }

  Future<void> _onUpdatePermissions(
      Emitter<SpaceState> emit,
      String selectedUserID,
      bool canComment,
      bool canEdit,
      bool canInvite,
      bool canRemove,
      bool canPost) async {
    emit(state.copyWith(updatePermissionsStatus: FormSubmitting()));
    try {
      await spaceRepo.updatePermissions(state.currentSpace.sid, selectedUserID,
          canComment, canEdit, canInvite, canRemove, canPost);
      emit(state.copyWith(
          getUsersStatus: InitialRetrievalStatus(),
          updatePermissionsStatus: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(
          updatePermissionsStatus: SubmissionFailed(Exception(e))));
    }
  }

  Future<void> _onKickUser(Emitter<SpaceState> emit, String uid) async {
    emit(state.copyWith(kickUserStatus: FormSubmitting()));
    try {
      await spaceRepo.removeUserFromSpace(currentSpaceData.sid, uid);
      UserData c = await userRepo.getCurrentUserData();
      emit(state.copyWith(
          getUsersStatus: InitialRetrievalStatus(),
          kickUserStatus: SubmissionSuccess(),
          currentUser: c));
    } catch (e) {
      emit(state.copyWith(kickUserStatus: SubmissionFailed(Exception(e))));
    }
  }

  Future<void> _getNewPosts(
      Emitter<SpaceState> emit, DateTime lastPostTime) async {
    try {
      final posts =
          await spaceRepo.getNewPosts(state.currentSpace.sid, lastPostTime);
      if (posts.isNotEmpty) {
        final replaceSpace = state.currentSpace;
        for (final post in posts) {
          if (!replaceSpace.spacePosts.contains(post)) {
            replaceSpace.spacePosts.add(post);
          }
        }
        emit(state.copyWith(currentSpace: replaceSpace));
      }
    } catch (e) {
      emit(state.copyWith(getNewPostsStatus: RetrievalFailed(Exception(e))));
    }
  }

  Future<void> _getUserHistory(Emitter<SpaceState> emit, String displayName,
      String email, String uid, String month, String year) async {
    emit(state.copyWith(getUserHistoryStatus: DataRetrieving()));
    try {
      final userHistory = await spaceRepo.getUserPostHistory(uid, month, year);
      if (userHistory.isEmpty) {
        String ret =
            "No Recorded $month/$year Post and Comment history for $displayName ($email).\n";
        await Clipboard.setData(ClipboardData(text: ret));
      } else {
        String spaceName = "";
        String ret =
            "$month/$year Post and Comment history for $displayName ($email):\n";

        for (final entry in userHistory) {
          if (spaceName != entry.spaceName) {
            ret += "\n-----${entry.spaceName}-----\n";
            spaceName = entry.spaceName;
          }
          String tag = entry.isComment ? "[C]" : "[P]";
          String print = "${entry.postedTime} \"${entry.contents}\" $tag\n";
          ret += print;
        }
        await Clipboard.setData(ClipboardData(text: ret));
      }
      emit(state.copyWith(
          getUserHistoryStatus: RetrievalSuccess(), userHistory: userHistory));
      emit(
          state.copyWith(getUserHistoryStatus: const InitialRetrievalStatus()));
    } catch (e) {
      emit(state.copyWith(getUserHistoryStatus: RetrievalFailed(Exception(e))));
    }
  }
}

  // async* allows us to yield values out the Stream


