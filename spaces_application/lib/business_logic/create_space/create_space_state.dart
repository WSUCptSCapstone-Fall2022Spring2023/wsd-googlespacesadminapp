import 'package:spaces_application/business_logic/auth/form_submission_status.dart';

class CreateSpaceState {
  final String name;
  bool get isValidName => name.length > 5;

  final String description;
  // bool isPrivate = true;

  //final File photo;

  final FormSubmissionStatus formStatus;

  CreateSpaceState({
    this.name = '',
    this.description = '',
    // this.isPrivate = true,
    //this.photo = null,
    this.formStatus = const InitialFormStatus(),
  });
  // CreateSpaceState({this.isPrivate}) {
  //   this.name = '',
  //   this.description = '',
  //   //this.photo = null,
  //   this.formStatus = const InitialFormStatus(),
  // }

  CreateSpaceState copyWith({
    String? name,
    String? description,
    // bool? isPrivate,
    // File? photo,
    FormSubmissionStatus? formStatus,
  }) {
    return CreateSpaceState(
      name: name ?? this.name,
      description: description ?? this.description,
      // isPrivate: isPrivate ?? this.isPrivate,
      // photo: photo ?? this.photo,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
