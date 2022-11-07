import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/auth/login/login_event.dart';
import 'package:spaces_application/business_logic/auth/login/login_state.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;

  LoginBloc({required this.authRepo}) : super(LoginState()) {
    on<LoginUsernameChanged>((event, emit) async {
      await _changeUsername(event.username, emit);
    });
    on<LoginPasswordChanged>((event, emit) async {
      await _changePassword(event.password, emit);
    });
    on<LoginSubmitted>((event, emit) async {
      await _changeFormStatus(emit);
    });
  }

  Future<void> _changeUsername(
      String newUsername, Emitter<LoginState> emit) async {
    emit(state.copyWith(username: newUsername));
  }

  Future<void> _changePassword(
      String newPassword, Emitter<LoginState> emit) async {
    emit(state.copyWith(password: newPassword));
  }

  Future<void> _changeFormStatus(Emitter<LoginState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    try {
      await authRepo.login();
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(Exception(e))));
    }
  }
}

  // async* allows us to yield values out the Stream


