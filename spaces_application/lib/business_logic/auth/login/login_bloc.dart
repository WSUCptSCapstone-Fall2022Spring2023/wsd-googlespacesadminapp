import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/auth/login/login_event.dart';
import 'package:spaces_application/business_logic/auth/login/login_state.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;

  LoginBloc({required this.authRepo}) : super(LoginState()) {
    on<LoginEmailChanged>((event, emit) async {
      await _onEmailChanged(event.email, emit);
    });
    on<LoginPasswordChanged>((event, emit) async {
      await _onPasswordChanged(event.password, emit);
    });
    on<LoginSubmitted>((event, emit) async {
      await _onFormStatusChanged(emit);
    });
  }

  Future<void> _onEmailChanged(
      String newEmail, Emitter<LoginState> emit) async {
    emit(state.copyWith(email: newEmail));
  }

  Future<void> _onPasswordChanged(
      String newPassword, Emitter<LoginState> emit) async {
    emit(state.copyWith(password: newPassword));
  }

  Future<void> _onFormStatusChanged(Emitter<LoginState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    try {
      await authRepo.login(state.email, state.password);
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(Exception(e))));
    }
  }
}

  // async* allows us to yield values out the Stream


