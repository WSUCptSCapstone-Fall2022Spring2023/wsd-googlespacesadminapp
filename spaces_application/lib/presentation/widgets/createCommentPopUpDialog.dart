import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';
import 'package:spaces_application/presentation/views/settingsView.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:spaces_application/business_logic/space/space_bloc.dart';
import 'package:spaces_application/business_logic/space/space_event.dart';
import 'package:spaces_application/business_logic/space/space_state.dart';
import 'package:spaces_application/data/repositories/space_repository.dart';
import 'package:spaces_application/presentation/widgets/navigation_drawer.dart';
import 'package:spaces_application/presentation/widgets/settingsDrawer.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../business_logic/auth/form_submission_status.dart';
import '../../business_logic/auth/login/login_bloc.dart';
import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';
import '../../data/repositories/userData_repository.dart';
import '../widgets/miscWidgets.dart';

class CreateCommentPopUpDialog extends StatelessWidget {
  CreateCommentPopUpDialog({required index});
  final index = 0;
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color darkViolet = const Color.fromARGB(255, 9, 5, 5);
  final Color navyBlue = const Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = const Color.fromARGB(255, 45, 40, 208);
  final Color majorelleBlue = const Color.fromARGB(255, 86, 85, 221);
  final Color salmon = const Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = const Color.fromARGB(255, 22, 12, 120);
  final Color lightPink = const Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = const Color.fromARGB(255, 255, 255, 240);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: BlocBuilder<SpaceBloc, SpaceState>(
          builder: (context, state) {
            return Dialog(
                insetPadding: const EdgeInsets.all(200),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          maxHeight: 50,
                                          maxWidth: 50,
                                          minWidth: 50,
                                          minHeight: 50),
                                      child: SvgPicture.string(
                                          FluttermojiFunctions()
                                              .decodeFluttermojifromString(state
                                                  .currentSpace
                                                  .spacePosts[index]
                                                  .postUser
                                                  .profilePicString)),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                            state.currentSpace.spacePosts[index]
                                                .postUser.displayName
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 25)),
                                        Text(
                                          "${state.currentSpace.spacePosts[index].postedTime.month.toString()}/${state.currentSpace.spacePosts[index].postedTime.day.toString()}/${state.currentSpace.spacePosts[index].postedTime.year.toString()} ${state.currentSpace.spacePosts[index].postedTime.hour.toString()}:${state.currentSpace.spacePosts[index].postedTime.minute.toString()}",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.left,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.black, size: 25),
                                    onPressed: (() {
                                      Navigator.pop(context);
                                    }),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  state.currentSpace.spacePosts[index].contents,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                            Flexible(
                                child: Container(
                                    color: Colors.orangeAccent,
                                    width: double.infinity,
                                    height: double.infinity,
                                    // child: BlocBuilder<CommentBloc, CommentState>(
                                    child: Column(
                                      children: [
                                        if (state.getCommentsStatus
                                            is DataRetrieving) ...[
                                          const SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()))
                                        ] else if (state.getCommentsStatus
                                                is RetrievalSuccess &&
                                            state.currentSpace.spacePosts[index]
                                                .comments.isEmpty) ...[
                                          const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [Text("No replies")])
                                        ] else if (state.getCommentsStatus
                                                is RetrievalSuccess &&
                                            state.currentSpace.spacePosts[index]
                                                .comments.isNotEmpty) ...[
                                          ListView.separated(
                                              separatorBuilder:
                                                  (context, index) {
                                                return const Divider(
                                                    height: 0.5);
                                              },
                                              shrinkWrap: false,
                                              itemCount: state
                                                  .currentSpace
                                                  .spacePosts[index]
                                                  .comments
                                                  .length,
                                              itemBuilder: (context, index2) {
                                                return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: ListTile(
                                                      dense: true,
                                                      leading: ConstrainedBox(
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxHeight: 30,
                                                                maxWidth: 30,
                                                                minWidth: 30,
                                                                minHeight: 30),
                                                        child: SvgPicture.string(
                                                            FluttermojiFunctions()
                                                                .decodeFluttermojifromString(state
                                                                    .currentSpace
                                                                    .spacePosts[
                                                                        index]
                                                                    .comments[
                                                                        index2]
                                                                    .commentUser
                                                                    .profilePicString)),
                                                      ),
                                                      selectedTileColor:
                                                          Colors.grey,
                                                      title: RichText(
                                                          text: TextSpan(
                                                              children: [
                                                            TextSpan(
                                                                text: state
                                                                    .currentSpace
                                                                    .spacePosts[
                                                                        index]
                                                                    .comments[
                                                                        index2]
                                                                    .commentUser
                                                                    .displayName
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        25)),
                                                            TextSpan(
                                                                text:
                                                                    "  ${state.currentSpace.spacePosts[index].comments[index2].commentedTime.month.toString()}/${state.currentSpace.spacePosts[index].comments[index2].commentedTime.day.toString()}/${state.currentSpace.spacePosts[index].comments[index2].commentedTime.year.toString()} ${state.currentSpace.spacePosts[index].comments[index2].commentedTime.hour.toString()}:${state.currentSpace.spacePosts[index].comments[index2].commentedTime.minute.toString()}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey))
                                                          ])),
                                                      subtitle: Text(state
                                                          .currentSpace
                                                          .spacePosts[index]
                                                          .comments[index2]
                                                          .contents),
                                                    ));
                                              })
                                        ] else if (state.getCommentsStatus
                                            is RetrievalFailed) ...[
                                          const Center(
                                              child: Text(
                                                  "Error with Data Retrieval. Please Refresh."))
                                        ] else ...[
                                          const SizedBox(
                                              width: 300,
                                              height: 100,
                                              child: Text(
                                                "Else Block",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 40),
                                              ))
                                        ]
                                      ],
                                    )
                                    // ]
                                    )),
                          ],
                        ))
                  ],
                ));
          },
        ));
  }
}
