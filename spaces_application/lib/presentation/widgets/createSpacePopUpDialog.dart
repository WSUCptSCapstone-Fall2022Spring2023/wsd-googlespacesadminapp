import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';
import '../../business_logic/create_space/create_space_bloc.dart';
import '../../business_logic/create_space/create_space_event.dart';
import '../../business_logic/create_space/create_space_state.dart';
import '../../data/repositories/space_repository.dart';
import '../../data/repositories/userData_repository.dart';

class CreateSpacePopUpDialog extends StatelessWidget {
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color darkViolet = const Color.fromARGB(255, 9, 5, 5);
  final Color navyBlue = const Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = const Color.fromARGB(255, 45, 40, 138);
  final Color majorelleBlue = const Color.fromARGB(255, 86, 85, 221);
  final Color salmon = const Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = const Color.fromARGB(255, 22, 12, 113);
  final Color lightPink = const Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = const Color.fromARGB(255, 255, 255, 240);
  bool privateSpaceChecked = false;
  bool value = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double userProfilePicConstraints = screenSize.width <= 500 ? 22 : 30;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 150, vertical: 250),
          backgroundColor: Colors.white,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          icon: Icon(Icons.close,
                              color: Colors.black, size: textSize * 1.2),
                          onPressed: (() {
                            Navigator.pop(context);
                          })),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Create a Space",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: textSize * 1.7)),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 0),
                    ),
                    BlocProvider(
                      create: (context) => CreateSpaceBloc(
                        spaceRepo: context.read<SpaceRepository>(),
                        userRepo: context.read<UserDataRepository>(),
                      ),
                      child: _createSpaceForm(context),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _createSpaceForm(BuildContext context) {
    bool isChecked = false;
    final Size screenSize = MediaQuery.of(context).size;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double userProfilePicConstraints = screenSize.width <= 500 ? 22 : 30;
    return BlocListener<CreateSpaceBloc, CreateSpaceState>(
        listenWhen: (previous, current) {
          if (current.formStatus == previous.formStatus) {
            return false;
          } else {
            return true;
          }
        },
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            MiscWidgets.showException(context, formStatus.exception.toString());
          } else if (formStatus is SubmissionSuccess) {
            // Navigate to new page
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(
            //     builder: (context) => HomeView(),
            //   ),
            // );
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeView(
                  currentUserData: state.currentUser!,
                ),
              ),
            );
            MiscWidgets.showException(context, "SPACE CREATION SUCCESS");
          }
        },
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _spaceNameField(context),
                const SizedBox(height: 10),
                _spaceDescriptionField(context),
                const SizedBox(height: 10),
                Container(
                    alignment: Alignment.center, child: _isPrivateCheckbox()),
                const SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                    color: Colors.black, width: 0.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: textSize * 0.9))),
                        const SizedBox(width: 10),
                        _createSpaceButton(context)
                      ],
                    )),
              ],
            )));
  }

  Widget _spaceNameField(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double userProfilePicConstraints = screenSize.width <= 500 ? 22 : 30;
    return BlocBuilder<CreateSpaceBloc, CreateSpaceState>(
        builder: (context, state) {
      return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black, fontSize: textSize),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'Space Name',
                hintStyle: TextStyle(color: Colors.grey, fontSize: textSize)),
            onChanged: (value) => context
                .read<CreateSpaceBloc>()
                .add(CreateSpaceNameChanged(name: value)),
          ));
    });
  }

  Widget _spaceDescriptionField(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double userProfilePicConstraints = screenSize.width <= 500 ? 22 : 30;
    return BlocBuilder<CreateSpaceBloc, CreateSpaceState>(
        builder: (context, state) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: TextFormField(
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black, fontSize: textSize),
            obscureText: false,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'Space Description',
                hintStyle: TextStyle(color: Colors.grey, fontSize: textSize)),
            //keyboardType: TextInputType.multiline,
            keyboardType: TextInputType.text,
            minLines: 4,
            maxLines: 16,
            onChanged: (value) => context
                .read<CreateSpaceBloc>()
                .add(CreateSpaceDescriptionChanged(description: value))),
      );
    });
  }

  Widget _isPrivateCheckbox() {
    return BlocBuilder<CreateSpaceBloc, CreateSpaceState>(
      builder: ((context, state) {
        return CheckboxListTile(
            selected: false,
            value: state.isPrivate,
            title: Text('Make Space Private?'),
            onChanged: (value) {
              context
                  .read<CreateSpaceBloc>()
                  .add(CreateSpaceIsPrivateChanged(isPrivate: value));
            });
      }),
    );
  }

  Widget _createSpaceButton(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double userProfilePicConstraints = screenSize.width <= 500 ? 22 : 30;
    return BlocBuilder<CreateSpaceBloc, CreateSpaceState>(
        builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<CreateSpaceBloc>().add(CreateSpaceSubmitted());
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  side: const BorderSide(color: Colors.black, width: 0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              child: Text('Create Space',
                  style: TextStyle(
                      color: Colors.white, fontSize: textSize * 0.9)));
    });
  }
}
