import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  LoginEmailChanged({required this.email});
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({required this.password});
}

class LoginSubmitted extends LoginEvent {}
