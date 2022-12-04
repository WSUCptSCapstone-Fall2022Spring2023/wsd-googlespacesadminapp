import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/create_space/create_space_event.dart';
import 'package:spaces_application/business_logic/create_space/create_space_state.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/data/repositories/space_repository.dart';

class CreateSpaceBloc extends Bloc<CreateSpaceEvent, CreateSpaceState> {
  final SpaceRepository spaceRepo;

  CreateSpaceBloc({required this.spaceRepo}) : super(CreateSpaceState()) {
    on<CreateSpaceNameChanged>((event, emit) async {
      await _onNameChanged(event.name, emit);
    });
    on<CreateSpaceSubmitted>((event, emit) async {
      await _onFormStatusChanged(emit);
    });
  }

  Future<void> _onNameChanged(
      String newName, Emitter<CreateSpaceState> emit) async {
    emit(state.copyWith(name: newName));
  }

  Future<void> _onFormStatusChanged(Emitter<CreateSpaceState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    try {
      await spaceRepo.createSpace(state.name);
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(Exception(e))));
    }
  }
}

  // async* allows us to yield values out the Stream


