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

class CreateSpaceBottomSheet extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color darkViolet = const Color.fromARGB(255, 9, 5, 5);
  final Color navyBlue = const Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = const Color.fromARGB(255, 45, 40, 138);
  final Color majorelleBlue = const Color.fromARGB(255, 86, 85, 221);
  final Color salmon = const Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = const Color.fromARGB(255, 22, 12, 113);
  final Color lightPink = const Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = const Color.fromARGB(255, 255, 255, 240);

  bool value = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Create a Space",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Divider(height: 0),
            ),
            BlocProvider(
              create: (context) => CreateSpaceBloc(
                spaceRepo: context.read<SpaceRepository>(),
              ),
              child: _createSpaceForm(),
            )
          ],
        ));
  }

  Widget _createSpaceForm() {
    bool isChecked = false;
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
            context.read<UserDataRepository>().getCurrentUserData();
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(
            //     builder: (context) => HomeView(),
            //   ),
            // );
            Navigator.pop(context);
            MiscWidgets.showException(context, "SPACE CREATION SUCCESS");
          }
        },
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _spaceNameField(),
                const SizedBox(height: 10),
                _spaceDescriptionField(),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  child: Row(children: const [
                    Text("Make Space private?",
                        style: TextStyle(color: Colors.black)),
                    Icon(Icons.check_box_outline_blank_outlined,
                        color: Colors.black)
                  ]),
                ),
                // _isPrivateCheckbox(),
                const SizedBox(height: 10),
                // _isPrivateCheckbox(),
                const SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: _createSpaceButton()),
              ],
            )));
  }

  Widget _spaceNameField() {
    return BlocBuilder<CreateSpaceBloc, CreateSpaceState>(
        builder: (context, state) {
      return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: TextFormField(
            style: const TextStyle(color: Colors.black, fontSize: 13),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'First Name',
                hintStyle: const TextStyle(color: Colors.black, fontSize: 13)),
            onChanged: (value) => context
                .read<CreateSpaceBloc>()
                .add(CreateSpaceNameChanged(name: value)),
          ));
    });
  }

  Widget _spaceDescriptionField() {
    return BlocBuilder<CreateSpaceBloc, CreateSpaceState>(
        builder: (context, state) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: TextFormField(
            style: const TextStyle(color: Colors.black, fontSize: 13),
            obscureText: false,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'Space Description',
                hintStyle: const TextStyle(color: Colors.black, fontSize: 13)),
            keyboardType: TextInputType.multiline,
            minLines: 4,
            maxLines: 10,
            onChanged: (value) => context
                .read<CreateSpaceBloc>()
                .add(CreateSpaceDescriptionChanged(description: value))),
      );
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
          ? const CircularProgressIndicator()
          : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context
                          .read<CreateSpaceBloc>()
                          .add(CreateSpaceSubmitted());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: salmon,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text('Create Space',
                      style: TextStyle(color: Colors.white, fontSize: 13))),
            );
    });
  }
}
