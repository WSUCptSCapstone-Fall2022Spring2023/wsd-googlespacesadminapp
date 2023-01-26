import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/business_logic/auth/register/register_bloc.dart';
import 'package:spaces_application/business_logic/auth/register/register_event.dart';
import 'package:spaces_application/business_logic/auth/register/register_state.dart';
import 'package:spaces_application/data/repositories/auth_repository.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';

class CreateStudentBottomSheet extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color darkViolet = Color.fromARGB(255, 9, 5, 5);
  final Color navyBlue = Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = Color.fromARGB(255, 45, 40, 138);
  final Color majorelleBlue = Color.fromARGB(255, 86, 85, 221);
  final Color salmon = Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = Color.fromARGB(255, 22, 12, 113);
  final Color lightPink = Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = Color.fromARGB(255, 255, 255, 240);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Student Creation",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Divider(height: 0),
            ),
            BlocProvider(
              create: (context) => RegisterBloc(
                authRepo: context.read<AuthRepository>(),
              ),
              child: _registerForm(),
            )
          ],
        ));
  }

  Widget _registerForm() {
    return BlocListener<RegisterBloc, RegisterState>(
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
            Navigator.pop(context);
            MiscWidgets.showException(context, "ACCOUNT CREATION SUCCESS");
          }
        },
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(children: [
                // Row(
                //   children: [
                //     _firstNameField(),
                //     const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                //     _lastNameField(),
                //   ],
                // ),
                _firstNameField(),
                const SizedBox(height: 10),
                _lastNameField(),
                const SizedBox(height: 10),
                _emailField(),
                const SizedBox(height: 10),
                _parentEmailField(),
                const SizedBox(height: 10),
                _registerButton(),
              ]),
            )));
  }

  Widget _emailField() {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: TextFormField(
            style: TextStyle(color: Colors.black, fontSize: 13),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black, fontSize: 13)),
            validator: (value) =>
                state.isValidEmail ? null : 'Not a valid Email',
            onChanged: (value) => context
                .read<RegisterBloc>()
                .add(RegisterEmailChanged(email: value)),
          ));
    });
  }

  Widget _parentEmailField() {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: TextFormField(
            style: TextStyle(color: Colors.black, fontSize: 13),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'Parent Email',
                hintStyle: TextStyle(color: Colors.black, fontSize: 13)),
            validator: (value) =>
                state.isValidParentEmail ? null : 'Not a valid Parent Email',
            onChanged: (value) => context
                .read<RegisterBloc>()
                .add(RegisterParentEmailChanged(parentEmail: value)),
          ));
    });
  }

  Widget _firstNameField() {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: TextFormField(
            style: const TextStyle(color: Colors.black, fontSize: 13),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'First Name',
                hintStyle: const TextStyle(color: Colors.black, fontSize: 13)),
            validator: (value) => state.isValidfirstName
                ? null
                : 'First Name must be between 2 - 20 characters',
            onChanged: (value) => context
                .read<RegisterBloc>()
                .add(RegisterFirstNameChanged(firstName: value)),
          ));
    });
  }

  Widget _lastNameField() {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: TextFormField(
            style: const TextStyle(color: Colors.black, fontSize: 13),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'Last Name',
                hintStyle: const TextStyle(color: Colors.black, fontSize: 13)),
            validator: (value) => state.isValidfirstName
                ? null
                : 'Last Name must be between 2 - 20 characters',
            onChanged: (value) => context
                .read<RegisterBloc>()
                .add(RegisterLastNameChanged(lastName: value)),
          ));
    });
  }

  Widget _registerButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<RegisterBloc>().add(RegisterSubmitted());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: salmon,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text('Register Account',
                      style: TextStyle(color: Colors.white, fontSize: 13))),
            );
    });
  }
}
