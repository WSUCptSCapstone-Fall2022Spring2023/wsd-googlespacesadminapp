import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:email_validator/email_validator.dart';

class RegisterState {
  final String email;
  final String parentEmail;
  final String firstName;
  final String lastName;
  //final int grade;
  bool get isValidEmail => (EmailValidator.validate(email));
  bool get isValidParentEmail => (EmailValidator.validate(parentEmail));
  bool get isValidfirstName => firstName.length > 1 && firstName.length < 21;
  bool get isValidlastName => lastName.length > 1 && lastName.length < 21;
  //bool get isValidGrade => grade > 0 && grade < 13;

  final FormSubmissionStatus formStatus;

  RegisterState({
    this.email = '',
    this.parentEmail = '',
    this.firstName = '',
    this.lastName = '',
    //this.grade = 0,
    this.formStatus = const InitialFormStatus(),
  });

  RegisterState copyWith({
    String? email,
    String? parentEmail,
    String? firstName,
    String? lastName,
    //int? grade,
    FormSubmissionStatus? formStatus,
  }) {
    return RegisterState(
      email: email ?? this.email,
      parentEmail: parentEmail ?? this.parentEmail,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      //grade: grade ?? this.grade,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
