import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/data/repositories/userData_repository.dart';
import 'edit_space_event.dart';
import 'edit_space_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UserDataRepository userRepo;
  final FluttermojiFunctions functions = FluttermojiFunctions();
  final FluttermojiController controller = FluttermojiController();

  EditProfileBloc({required this.userRepo}) : super(EditProfileState()) {
    on<ProfileFirstNameChanged>((event, emit) async {
      await _onFirstNameChanged(event.firstName, emit);
    });
    on<ProfileLastNameChanged>((event, emit) async {
      await _onLastNameChanged(event.lastName, emit);
    });
    on<ProfileDisplayNameChanged>((event, emit) async {
      await _onDisplayNameChanged(event.displayName, emit);
    });
    on<ProfileSubmitted>((event, emit) async {
      await _onFormStatusChanged(emit);
    });
  }

  Future<void> _onFirstNameChanged(
      String newName, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(firstName: newName));
  }

  Future<void> _onLastNameChanged(
      String newName, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(lastName: newName));
  }

  Future<void> _onDisplayNameChanged(
      String newName, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(displayName: newName));
  }

  Future<void> _onFormStatusChanged(Emitter<EditProfileState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    try {
      final profilePicString = await functions.encodeMySVGtoString();
      await userRepo.setCurrentUserData(profilePicString, state.displayName!);
      final currentUserData = await userRepo.getCurrentUserData();
      //final pp = functions.decodeFluttermojifromString(
      //  userRepo.currentUserData.profilePicString);
      //await controller.setFluttermoji(
      //  fluttermojiNew: userRepo.currentUserData.profilePicString);
      emit(state.copyWith(
          formStatus: SubmissionSuccess(), currentUser: currentUserData));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(Exception(e))));
    }
  }
}

  // async* allows us to yield values out the Stream


