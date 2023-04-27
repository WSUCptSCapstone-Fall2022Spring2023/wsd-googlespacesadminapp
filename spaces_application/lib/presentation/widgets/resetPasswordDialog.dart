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
import '../../data/repositories/userData_repository.dart';

class ResetPasswordDialog extends StatelessWidget {
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color darkViolet = const Color.fromARGB(255, 9, 5, 5);
  final Color navyBlue = const Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = const Color.fromARGB(255, 45, 40, 138);
  final Color majorelleBlue = const Color.fromARGB(255, 86, 85, 221);
  final Color salmon = const Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = const Color.fromARGB(255, 22, 12, 113);
  final Color lightPink = const Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = const Color.fromARGB(255, 255, 255, 240);

  @override
  Widget build(BuildContext context) {
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
                          icon: const Icon(Icons.close,
                              color: Colors.black, size: 25),
                          onPressed: (() {
                            Navigator.pop(context);
                          })),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Reset Password",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 35)),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 0),
                    ),
                    _createSpaceForm(context),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _createSpaceForm(BuildContext context) {
    bool isChecked = false;
    return BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) {
          if (current.resetStatus == previous.resetStatus) {
            return false;
          } else {
            return true;
          }
        },
        listener: (context, state) {
          final formStatus = state.resetStatus;
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
            MiscWidgets.showException(context,
                "A reset email has been sent to the submitted email address.");
          }
        },
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _emailField(),
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
                            child: const Text('Cancel',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18))),
                        const SizedBox(width: 10),
                        _submitPasswordReset()
                      ],
                    )),
              ],
            )));
  }

  Widget _emailField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: TextFormField(
            style: TextStyle(color: Colors.black, fontSize: 20),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 20)),
            validator: (value) =>
                state.isValidResetEmail ? null : 'Not a valid Email',
            onChanged: (value) =>
                context.read<LoginBloc>().add(ResetEmailChanged(email: value)),
          ));
    });
  }

  Widget _submitPasswordReset() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.resetStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(PasswordResetSubmit());
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  side: const BorderSide(color: Colors.black, width: 0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              child: const Text('Reset',
                  style: TextStyle(color: Colors.white, fontSize: 18)));
    });
  }
}