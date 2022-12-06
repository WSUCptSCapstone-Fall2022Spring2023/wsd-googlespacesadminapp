import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/auth/register/register_event.dart';
import 'package:spaces_application/business_logic/auth/register/register_state.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepo;

  RegisterBloc({required this.authRepo}) : super(RegisterState()) {
    on<RegisterEmailChanged>((event, emit) async {
      await _onEmailChanged(event.email, emit);
    });
    on<RegisterParentEmailChanged>((event, emit) async {
      await _onParentEmailChanged(event.parentEmail, emit);
    });
    on<RegisterFirstNameChanged>((event, emit) async {
      await _onFirstNameChanged(event.firstName, emit);
    });
    on<RegisterLastNameChanged>((event, emit) async {
      await _onLastNameChanged(event.lastName, emit);
    });
    // on<RegisterGradeChanged>((event, emit) async {
    //   await _onGradeChanged(event.grade, emit);
    // });
    on<RegisterSubmitted>((event, emit) async {
      await _onFormStatusChanged(emit);
    });
  }

  Future<void> _onEmailChanged(
      String newEmail, Emitter<RegisterState> emit) async {
    emit(state.copyWith(email: newEmail));
  }

  Future<void> _onParentEmailChanged(
      String newEmail, Emitter<RegisterState> emit) async {
    emit(state.copyWith(parentEmail: newEmail));
  }

  Future<void> _onFirstNameChanged(
      String newName, Emitter<RegisterState> emit) async {
    emit(state.copyWith(firstName: newName));
  }

  Future<void> _onLastNameChanged(
      String newName, Emitter<RegisterState> emit) async {
    emit(state.copyWith(lastName: newName));
  }

  //Future<void> _onGradeChanged(
  //     int newGrade, Emitter<RegisterState> emit) async {
  //  emit(state.copyWith(grade: newGrade));
  //}

  Future<void> _onFormStatusChanged(Emitter<RegisterState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    try {
      await authRepo.register(
          state.email, state.parentEmail, state.firstName, state.lastName);
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(Exception(e))));
    }
  }
}

  // async* allows us to yield values out the Stream


