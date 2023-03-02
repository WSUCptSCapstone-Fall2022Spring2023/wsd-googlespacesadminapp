import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/presentation/views/settingsView.dart';
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
        backgroundColor: Colors.white,
        drawer: NavigationDrawer(
          currentUserData: currentUserData,
        ),
        appBar: AppBar(
          elevation: 15,
          // title: Text(currentSpace.spaceName,
          title: Text(currentSpace.spacePosts.length.toString(),
              style: TextStyle(color: Colors.black)),
          iconTheme: IconThemeData(color: Colors.black, size: 30),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => SettingsView(
                            currentUserData: currentUserData,
                          )));
                })
          ],
        ),
        body: BlocProvider(
            // Loads posts into state.currentSpace.spacePosts upon initialization
            create: (context) => PostBloc(
                  spaceRepo: context.read<SpaceRepository>(),
                  userRepo: context.read<UserDataRepository>(),
                  currentUserData: currentUserData,
                )..add(LoadCurrentSpace(currentSpace: currentSpace)),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Flexible(
                  child: Container(
                      color: Colors.deepOrangeAccent,
                      width: double.infinity,
                      height: double.infinity,
                      child: BlocBuilder<PostBloc, PostState>(
                        builder: ((context, state) {
                          if (state.currentSpace == null) {
                            return Container(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator());
                          } else if (state.currentSpace!.spacePosts.length ==
                              0) {
                            return Text("Space has no Posts. ");
                          } else {
                            return ListView.builder(
                                shrinkWrap: false,
                                itemCount:
                                    state.currentSpace!.spacePosts.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                      title: Text(state.currentSpace!
                                          .spacePosts[index].contents));
                                });
                            // return Text(
                            //     state.currentSpace!.spacePosts[0].contents);
                          }
                        }),
                      )),
                ),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _createPostForm())
              ]),
            )));
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
            // _formKey.currentState!.reset();
          }
        },
        child: Form(
            key: _formKey,
            child: Row(
              children: [
                _messageField(),
                const SizedBox(width: 10),
                _createPostButton(),
              ],
            )));
  }

  Widget _messageField() {
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      return Flexible(
        child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: TextFormField(
              style: const TextStyle(color: Colors.black, fontSize: 13),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  hintText: 'Message ${currentSpace.spaceName}',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13)),
              onChanged: (value) => context
                  .read<PostBloc>()
                  .add(PostMessageChanged(message: value)),
              onFieldSubmitted: (value) => context
                  .read<PostBloc>()
                  .add(PostMessageChanged(message: value)),
            )),
      );
    });
  }

  Widget _createPostButton() {
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<PostBloc>().add(PostSubmitted());
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black, width: 0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              child: const Text('Post',
                  style: TextStyle(color: Colors.black, fontSize: 13)));
    });
  }
}
