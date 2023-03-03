import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:spaces_application/presentation/views/settingsView.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:spaces_application/business_logic/post/create_post_bloc.dart';
import 'package:spaces_application/business_logic/post/create_post_event.dart';
import 'package:spaces_application/business_logic/post/create_post_state.dart';
import 'package:spaces_application/data/repositories/space_repository.dart';
import 'package:spaces_application/presentation/widgets/navigation_drawer.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  final Color bgColor = const Color.fromARGB(255, 49, 49, 49);
  final Color textColor = const Color.fromARGB(255, 246, 246, 176);
  final Color boxColor = const Color.fromARGB(255, 60, 60, 60);
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
          title: Text(currentSpace.spaceName,
              style: const TextStyle(color: Colors.black)),
          iconTheme: const IconThemeData(color: Colors.black, size: 30),
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
                      color: Colors.white,
                      width: double.infinity,
                      height: double.infinity,
                      child: BlocBuilder<PostBloc, PostState>(
                        builder: ((context, state) {
                          if (state.currentSpace == null) {
                            return const SizedBox(
                                width: 100,
                                height: 100,
                                child:
                                    Center(child: CircularProgressIndicator()));
                          } else if (state.currentSpace!.spacePosts.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/SchoolLearning.jpg',
                                  width: 400,
                                  height: 400,
                                ),
                                const Text(
                                    "This space has no Posts. Be the First!"),
                              ],
                            );
                          } else {
                            return ListView.builder(
                                shrinkWrap: false,
                                itemCount:
                                    state.currentSpace!.spacePosts.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ListTile(
                                        dense: true,
                                        leading: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxHeight: 50,
                                              maxWidth: 50,
                                              minWidth: 50,
                                              minHeight: 50),
                                          child: SvgPicture.string(
                                              FluttermojiFunctions()
                                                  .decodeFluttermojifromString(
                                                      state
                                                          .currentSpace!
                                                          .spacePosts[index]
                                                          .postUser
                                                          .profilePicString)),
                                        ),
                                        shape: const Border(
                                            top: BorderSide(width: 5)),
                                        title: RichText(
                                            text: TextSpan(
                                                style: const TextStyle(),
                                                children: [
                                              TextSpan(
                                                  text: state
                                                      .currentSpace!
                                                      .spacePosts[index]
                                                      .postUser
                                                      .displayName
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 25)),
                                              TextSpan(
                                                  text:
                                                      "  ${state.currentSpace!.spacePosts[index].postedTime.month.toString()}/${state.currentSpace!.spacePosts[index].postedTime.day.toString()}/${state.currentSpace!.spacePosts[index].postedTime.year.toString()} ${state.currentSpace!.spacePosts[index].postedTime.hour.toString()}:${state.currentSpace!.spacePosts[index].postedTime.minute.toString()}",
                                                  style: const TextStyle(
                                                      color: Colors.grey))
                                            ])),
                                        subtitle: Text(
                                            state.currentSpace!
                                                .spacePosts[index].contents,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w300)),
                                        focusColor: Colors.grey,
                                        isThreeLine: true,
                                        trailing: PopupMenuButton(
                                          onSelected: ((value) {
                                            if (value == '/edit') {
                                              MiscWidgets.showException(
                                                  context, "Edit Message");
                                            } else if (value == '/delete') {
                                              MiscWidgets.showException(
                                                  context, "Delete Message");
                                            }
                                          }),
                                          itemBuilder: (context) {
                                            return const [
                                              PopupMenuItem(
                                                  value: '/edit',
                                                  child: Text("Edit")),
                                              PopupMenuItem(
                                                  value: '/delete',
                                                  child: Text("Delete"))
                                            ];
                                          },
                                        )),
                                  );
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
