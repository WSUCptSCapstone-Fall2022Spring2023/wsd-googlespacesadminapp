import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/auth/form_submission_status.dart';
import 'package:spaces_application/auth/login/login_event.dart';
import 'package:spaces_application/auth/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState());

  // async* allows us to yield values out the Stream
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginUsernameChanged) {
      yield state.copyWith(username: event.username);
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
    }
  }
}
