import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:spaces_application/business_logic/post/create_post_bloc.dart';
import 'package:spaces_application/business_logic/post/create_post_event.dart';
import 'package:spaces_application/business_logic/post/create_post_state.dart';
import 'package:spaces_application/data/repositories/space_repository.dart';
import 'package:spaces_application/presentation/widgets/navigation_drawer.dart';
import 'package:uuid/uuid.dart';

import '../../business_logic/auth/form_submission_status.dart';
import '../../business_logic/auth/login/login_bloc.dart';
import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';
import '../../data/repositories/userData_repository.dart';
import '../widgets/miscWidgets.dart';

class SpaceView extends StatelessWidget {
  SpaceView({required this.currentSpace, required this.currentUserData});
  SpaceData currentSpace;
  final UserData currentUserData;
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color bgColor = Color.fromARGB(255, 49, 49, 49);
  final Color textColor = Color.fromARGB(255, 246, 246, 176);
  final Color boxColor = Color.fromARGB(255, 60, 60, 60);
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
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: bgColor,
        drawer: NavigationDrawer(
          currentUserData: currentUserData,
        ),
        appBar: AppBar(
          elevation: 15,
          title: Text(currentSpace.spaceName),
          backgroundColor: bgColor,
        ),
        body: BlocProvider(
            // Loads posts into state.currentSpace.spacePosts upon initialization
            create: (context) => PostBloc(
                  spaceRepo: context.read<SpaceRepository>(),
                  userRepo: context.read<UserDataRepository>(),
                  currentUserData: currentUserData,
                )..add(LoadCurrentSpace(currentSpace: currentSpace)),
            child: Container(
                alignment: AlignmentDirectional.bottomCenter,
                child: _createPostForm())));
  }

  Widget _createPostForm() {
    return BlocListener<PostBloc, PostState>(
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
            MiscWidgets.showException(context, "POST SUCCESS");
          }
        },
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _messageField(),
                const SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: _createPostButton()),
              ],
            )));
  }

  Widget _messageField() {
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
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
                hintText: 'Message',
                hintStyle: const TextStyle(color: Colors.black, fontSize: 13)),
            onChanged: (value) => context
                .read<PostBloc>()
                .add(PostMessageChanged(message: value)),
          ));
    });
  }

  Widget _createPostButton() {
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<PostBloc>().add(PostSubmitted());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: salmon,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text('Create Post',
                      style: TextStyle(color: Colors.white, fontSize: 13))),
            );
    });
  }
}
