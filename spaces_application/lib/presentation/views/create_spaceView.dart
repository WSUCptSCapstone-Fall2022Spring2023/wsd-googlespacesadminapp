import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/login/login_bloc.dart';
import 'package:spaces_application/business_logic/auth/login/login_event.dart';
import 'package:spaces_application/business_logic/auth/login/login_state.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';
import '../../business_logic/create_space/create_space_bloc.dart';
import '../../business_logic/create_space/create_space_event.dart';
import '../../business_logic/create_space/create_space_state.dart';
import '../../data/repositories/space_repository.dart';

class CreateSpaceView extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color bgColor = Color.fromARGB(255, 12, 12, 12);
  final Color textColor = Color.fromARGB(255, 255, 255, 240);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: Container(
          alignment: Alignment.center,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: boxColor,
              ),
              width: 500,
              height: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.space_dashboard, size: 50, color: textColor),
                      Text("Create a Space",
                          textScaleFactor: 2,
                          style: TextStyle(color: textColor)),
                    ],
                  ),
                  BlocProvider(
                    create: (context) => CreateSpaceBloc(
                      spaceRepo: context.read<SpaceRepository>(),
                    ),
                    child: _createSpaceForm(),
                  )
                ],
              )),
        ));
  }

  Widget _createSpaceForm() {
    return BlocListener<CreateSpaceBloc, CreateSpaceState>(
        listenWhen: (previous, current) {
          if (current.formStatus == previous.formStatus)
            return false;
          else
            return true;
        },
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            MiscWidgets.showException(context, formStatus.exception.toString());
          } else if (formStatus is SubmissionSuccess) {
            // Navigate to new page
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeView(),
              ),
            );
            MiscWidgets.showException(context, "SPACE CREATION SUCCESS");
          }
        },
        child: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _spaceNameField(),
                    Padding(padding: EdgeInsets.all(4)),
                    _spaceDescriptionField(),
                    Padding(padding: EdgeInsets.all(2)),
                    // _isPrivateCheckbox(),
                    Padding(padding: EdgeInsets.all(2)),
                    _createSpaceButton(),
                  ],
                ))));
  }

  Widget _spaceNameField() {
    return BlocBuilder<CreateSpaceBloc, CreateSpaceState>(
        builder: (context, state) {
      return TextFormField(
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor, width: 0.0)),
            hintText: 'Space Name',
            hintStyle: TextStyle(color: textColor)),
        // validator returns null when valid value is passed
        // alternative syntax:
        // String TextFormField.validator(value) {
        //   if state.isValidUsername()
        //     return null;
        //   else
        //     return "Username is too short";
        // }
        onChanged: (value) => context
            .read<CreateSpaceBloc>()
            .add(CreateSpaceNameChanged(name: value)),
      );
    });
  }

  Widget _spaceDescriptionField() {
    return BlocBuilder<CreateSpaceBloc, CreateSpaceState>(
        builder: (context, state) {
      return TextFormField(
          style: TextStyle(color: textColor),
          obscureText: false,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor, width: 0.0)),
              hintText: 'Space Description',
              hintStyle: TextStyle(color: textColor)),
          keyboardType: TextInputType.multiline,
          minLines: 4,
          maxLines: 10,
          onChanged: (value) => context
              .read<CreateSpaceBloc>()
              .add(CreateSpaceDescriptionChanged(description: value)));
    });
  }

  // Widget _isPrivateCheckbox() {
  //   // bool _value = false;

  //   return BlocBuilder<CreateSpaceBloc, CreateSpaceState>(
  //     builder: ((context, state) {
  //       return CheckboxListTile(
  //           selected: false,
  //           value: false,
  //           title: Text('Make Space Private?'),
  //           // onChanged: (value) => context
  //           //     .read()<CreateSpaceBloc>()
  //           //     .add(CreateSpaceIsPrivateChanged(isPrivate: _value)));
  //           onChanged: (newBool) {
  //             context
  //                 .read<CreateSpaceBloc>()
  //                 .add(CreateSpaceIsPrivateChanged(isPrivate: newBool));
  //           });
  //     }),
  //   );
  // }

  Widget _createSpaceButton() {
    return BlocBuilder<CreateSpaceBloc, CreateSpaceState>(
        builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<CreateSpaceBloc>().add(CreateSpaceSubmitted());
                }
              },
              child: Text('Create Space'),
              style: ElevatedButton.styleFrom());
    });
  }
}
