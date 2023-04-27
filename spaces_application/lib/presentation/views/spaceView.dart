import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:spaces_application/business_logic/data_retrieval_status.dart';
import 'package:spaces_application/data/models/postData.dart';
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
import 'package:intl/intl.dart';
import 'package:link_text/link_text.dart';

import '../../business_logic/auth/form_submission_status.dart';
import '../../business_logic/auth/login/login_bloc.dart';
import '../../data/models/spaceData.dart';
import '../../data/models/userData.dart';
import '../../data/repositories/userData_repository.dart';
import '../widgets/editMessagePopUp.dart';
import '../widgets/miscWidgets.dart';

class SpaceView extends StatefulWidget {
  SpaceView({required this.currentSpace, required this.currentUserData});
  SpaceData currentSpace;
  final UserData currentUserData;

  @override
  State<SpaceView> createState() => _SpaceViewState();
}

class _SpaceViewState extends State<SpaceView> {
  _SpaceViewState();

  final _formKey = GlobalKey<FormState>();
  late SpaceBloc _spaceBloc;

  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _postScrollController = ScrollController();
  final ScrollController _commentScrollController = ScrollController();
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
  void initState() {
    super.initState();
    _spaceBloc = SpaceBloc(
      spaceRepo: context.read<SpaceRepository>(),
      userRepo: context.read<UserDataRepository>(),
      currentUserData: widget.currentUserData,
      currentSpaceData: widget.currentSpace,
    )..add(LoadSpacePosts());
    _postScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_postScrollController.position.pixels ==
        _postScrollController.position.maxScrollExtent) {
      _spaceBloc.add(LoadMoreSpacePosts());
    }
  }

  void getNewPosts(BuildContext context) {
    Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        var state = _spaceBloc.state;
        context.read<SpaceBloc>().add(GetNewPosts(
            lastPostTime: state.currentSpace.spacePosts.last.postedTime));
        // if (state.newPosts.isNotEmpty) {
        //   state.copyWith(getNewPostsStatus: DataRetrieving());
        //   state.newPosts.clear();
        // }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //_scrollController.addListener(_scrollListener);
    var screenWidth = MediaQuery.of(context).size.width;
    final Size screenSize = MediaQuery.of(context).size;
    final double imageWidth = screenSize.width * 0.7;
    final double imageHeight = screenSize.height * 0.4;
    final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
    final double textSize = screenSize.width <= 500 ? 12 : 20;
    final double postBoxConstraints = screenSize.width <= 500 ? 30 : 50;
    return BlocProvider<SpaceBloc>(
        create: (context) {
          return _spaceBloc;
        },
        child:
            BlocBuilder<SpaceBloc, SpaceState>(buildWhen: (previous, current) {
          if (ModalRoute.of(context)?.isCurrent == true) {
            return true;
          } else {
            return false;
          }
        }, builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            drawer: MyNavigationDrawer(
              currentUserData: widget.currentUserData,
            ),
            endDrawer: SettingsDrawer(
              currentUserData: widget.currentUserData,
              currentSpace: widget.currentSpace,
            ),
            appBar: AppBar(
              elevation: 15,
              // title: Text(currentSpace.spaceName,
              title: Text(widget.currentSpace.spaceName,
                  style: const TextStyle(color: Colors.white)),
              iconTheme: const IconThemeData(color: Colors.white, size: 30),
              backgroundColor: bgColor,
              actions: [
                Builder(
                    builder: (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                        icon: const Icon(Icons.settings)))
              ],
            ),
            body: Column(children: [
              Flexible(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                    child: BlocBuilder<SpaceBloc, SpaceState>(
                      builder: ((context, state) {
                        // build Progress indicator when posts are being retrieved
                        if (state.getPostsStatus is DataRetrieving) {
                          getNewPosts(context);
                          return const SizedBox(
                              width: 100,
                              height: 100,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }
                        // build empty space pic/text when there are no posts
                        else if (state.getPostsStatus is RetrievalSuccess &&
                            state.currentSpace.spacePosts.isEmpty) {
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
                        }
                        // build posts when there are posts
                        else if ((state.getPostsStatus is RetrievalSuccess &&
                                state.currentSpace.spacePosts.isNotEmpty) ||
                            state.getNewPostsStatus is RetrievalSuccess) {
                          return ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              reverse: true,
                              controller: _postScrollController,
                              shrinkWrap: true,
                              itemCount:
                                  state.currentSpace.spacePosts.length + 1,
                              itemBuilder: (context, index) {
                                final reversedIndex =
                                    state.currentSpace.spacePosts.length -
                                        1 -
                                        index;
                                if (index ==
                                    state.currentSpace.spacePosts.length) {
                                  bool isLoading = state.getMorePostsStatus
                                      is DataRetrieving;
                                  return SizedBox(
                                      height: 5,
                                      child: isLoading
                                          ? const LinearProgressIndicator()
                                          : null);
                                }
                                return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ListTile(
                                        dense: true,
                                        leading: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight: postBoxConstraints,
                                              maxWidth: postBoxConstraints,
                                              minWidth: postBoxConstraints,
                                              minHeight: postBoxConstraints),
                                          child: SvgPicture.string(
                                              FluttermojiFunctions()
                                                  .decodeFluttermojifromString(
                                                      state
                                                          .currentSpace
                                                          .spacePosts[
                                                              reversedIndex]
                                                          .postUser
                                                          .profilePicString)),
                                        ),
                                        shape: const Border(
                                            top: BorderSide(width: 5)),
                                        selectedTileColor: Colors.grey,
                                        title: RichText(
                                            text: TextSpan(
                                                style: const TextStyle(),
                                                children: [
                                              if (state
                                                  .currentSpace
                                                  .spacePosts[reversedIndex]
                                                  .postUser
                                                  .isFaculty)
                                                TextSpan(
                                                    text: "[A] ",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize:
                                                            textSize * 1.2)),
                                              TextSpan(
                                                  text: state
                                                      .currentSpace
                                                      .spacePosts[reversedIndex]
                                                      .postUser
                                                      .displayName
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize:
                                                          textSize * 1.2)),
                                              TextSpan(
                                                  text:
                                                      "  ${DateFormat('MM-dd-yyyy hh:mm a').format(state.currentSpace.spacePosts[reversedIndex].postedTime)}",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: textSize)),
                                              if (state
                                                  .currentSpace
                                                  .spacePosts[reversedIndex]
                                                  .isEdited)
                                                TextSpan(
                                                    text: "  (edited)",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: textSize))
                                            ])),
                                        subtitle: LinkText(
                                          "${state.currentSpace.spacePosts[reversedIndex].contents} ",
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: textSize * 1.2,
                                              fontWeight: FontWeight.normal),
                                          linkStyle: TextStyle(
                                              color: Colors.red,
                                              fontSize: textSize * 1.2,
                                              fontWeight: FontWeight.normal,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                        isThreeLine: true,
                                        trailing: PopupMenuButton(
                                          iconSize: textSize * 1.3,
                                          onSelected: ((value) {
                                            if (value == '/reply') {
                                              MiscWidgets.showException(
                                                  (context), "reply");
                                            } else if (value == '/edit') {
                                              showDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder: (_) {
                                                  return BlocProvider.value(
                                                    value: BlocProvider.of<
                                                        SpaceBloc>(context),
                                                    child: EditMessagePopUp(
                                                        post: state.currentSpace
                                                                .spacePosts[
                                                            reversedIndex]),
                                                  );
                                                },
                                              );
                                            } else if (value == '/delete') {
                                              context.read<SpaceBloc>().add(
                                                  RemovePost(
                                                      selectedPost: state
                                                              .currentSpace
                                                              .spacePosts[
                                                          reversedIndex]));
                                            }
                                          }),
                                          itemBuilder: (context) {
                                            if (state.deletePostStatus
                                                is DataRetrieving) {
                                              return const [
                                                PopupMenuItem(
                                                    child:
                                                        CircularProgressIndicator())
                                              ];
                                            } else {
                                              if (state.currentUser.uid ==
                                                      state
                                                          .currentSpace
                                                          .spacePosts[
                                                              reversedIndex]
                                                          .postUser
                                                          .uid ||
                                                  (state.permissions!
                                                          .canRemove &&
                                                      state.permissions!
                                                          .canEdit)) {
                                                return const [
                                                  PopupMenuItem(
                                                      value: '/edit',
                                                      child: Text("Edit")),
                                                  PopupMenuItem(
                                                      value: '/delete',
                                                      child: Text("Delete"))
                                                ];
                                              } else if (state
                                                  .permissions!.canRemove) {
                                                return const [
                                                  PopupMenuItem(
                                                      value: '/delete',
                                                      child: Text("Delete")),
                                                ];
                                              } else if (state
                                                  .permissions!.canEdit) {
                                                return const [
                                                  PopupMenuItem(
                                                      value: '/edit',
                                                      child: Text("Edit")),
                                                ];
                                              } else {
                                                return const [
                                                  PopupMenuItem(
                                                      child: SizedBox.shrink())
                                                ];
                                              }
                                            }
                                          },
                                        ),
                                        onTap: () {
                                          showDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: ((_) {
                                                final double
                                                    commentBoxConstraints =
                                                    screenSize.width <= 500
                                                        ? 20
                                                        : 30;

                                                return BlocProvider.value(
                                                    value: BlocProvider.of<
                                                        SpaceBloc>(context)
                                                      ..add(LoadPostComments(
                                                          selectedPost: state
                                                                  .currentSpace
                                                                  .spacePosts[
                                                              reversedIndex])),
                                                    child: Dialog(
                                                        insetPadding: EdgeInsets
                                                            .all((screenSize
                                                                        .width <=
                                                                    1000)
                                                                ? 30
                                                                : 50),
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: <Widget>[
                                                            Container(
                                                                width: double
                                                                    .infinity,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 7),
                                                                child: Column(
                                                                  children: [
                                                                    Material(
                                                                      elevation:
                                                                          2,
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 5.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  ConstrainedBox(
                                                                                    constraints: BoxConstraints(maxHeight: commentBoxConstraints * 1.8, maxWidth: commentBoxConstraints * 1.8, minWidth: commentBoxConstraints * 1.8, minHeight: commentBoxConstraints * 1.8),
                                                                                    child: SvgPicture.string(FluttermojiFunctions().decodeFluttermojifromString(state.currentSpace.spacePosts[reversedIndex].postUser.profilePicString)),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      RichText(
                                                                                          textAlign: TextAlign.left,
                                                                                          text: TextSpan(style: const TextStyle(), children: [
                                                                                            if (state.currentSpace.spacePosts[reversedIndex].postUser.isFaculty) TextSpan(text: "[A] ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.normal, fontSize: textSize * 1.2)),
                                                                                            TextSpan(text: state.currentSpace.spacePosts[reversedIndex].postUser.displayName.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: textSize * 1.2))
                                                                                          ])),
                                                                                      Text(
                                                                                        " ${DateFormat('MM-dd-yyyy hh:mm a').format(state.currentSpace.spacePosts[reversedIndex].postedTime)}",
                                                                                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: textSize),
                                                                                        textAlign: TextAlign.left,
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Align(
                                                                              alignment: Alignment.topRight,
                                                                              child: IconButton(
                                                                                icon: Icon(Icons.close, color: Colors.black, size: textSize * 1.5),
                                                                                onPressed: (() {
                                                                                  Navigator.pop(context);
                                                                                }),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Material(
                                                                      elevation:
                                                                          2,
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              vertical: 8,
                                                                              horizontal: 20),
                                                                          child:
                                                                              LinkText(
                                                                            state.currentSpace.spacePosts[reversedIndex].contents,
                                                                            textStyle: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: textSize * 1.2,
                                                                                fontWeight: FontWeight.normal),
                                                                            linkStyle: TextStyle(
                                                                                color: Colors.red,
                                                                                fontSize: textSize * 1.2,
                                                                                fontWeight: FontWeight.normal,
                                                                                decoration: TextDecoration.underline),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                        child: Container(
                                                                            decoration: const BoxDecoration(
                                                                              // border: Border(top: BorderSide(width: 0.2, color: Colors.black)),
                                                                              color: Colors.white,
                                                                            ),
                                                                            width: double.infinity,
                                                                            height: double.infinity,
                                                                            // child: BlocBuilder<CommentBloc, CommentState>(
                                                                            child: BlocBuilder<SpaceBloc, SpaceState>(builder: (context, state) {
                                                                              if (state.getCommentsStatus is RetrievalSuccess) {
                                                                                return ListView(
                                                                                  children: [
                                                                                    if (state.getCommentsStatus is DataRetrieving) ...[
                                                                                      const SizedBox(width: 100, height: 100, child: Center(child: CircularProgressIndicator()))
                                                                                    ] else if (state.getCommentsStatus is RetrievalSuccess && state.selectedPost!.comments.isEmpty) ...[
                                                                                      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                                                        Padding(
                                                                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                            child: Text(
                                                                                              "No replies",
                                                                                              style: TextStyle(fontSize: textSize),
                                                                                            ))
                                                                                      ])
                                                                                    ] else if (state.getCommentsStatus is RetrievalSuccess && state.selectedPost!.comments.isNotEmpty) ...[
                                                                                      ListView.builder(
                                                                                          physics: const ClampingScrollPhysics(),
                                                                                          controller: _commentScrollController,
                                                                                          reverse: true,
                                                                                          shrinkWrap: true,
                                                                                          itemCount: state.selectedPost!.comments.length,
                                                                                          itemBuilder: (context, index2) {
                                                                                            final reversedIndex2 = state.selectedPost!.comments.length - 1 - index2;
                                                                                            return Padding(
                                                                                                padding: const EdgeInsets.all(10),
                                                                                                child: ListTile(
                                                                                                  dense: true,
                                                                                                  leading: ConstrainedBox(
                                                                                                    constraints: BoxConstraints(maxHeight: commentBoxConstraints * 1.4, maxWidth: commentBoxConstraints * 1.4, minWidth: commentBoxConstraints * 1.4, minHeight: commentBoxConstraints * 1.4),
                                                                                                    child: SvgPicture.string(FluttermojiFunctions().decodeFluttermojifromString(state.selectedPost!.comments[reversedIndex2].commentUser.profilePicString)),
                                                                                                  ),
                                                                                                  shape: const Border(top: BorderSide(width: 5)),
                                                                                                  selectedTileColor: Colors.grey,
                                                                                                  title: RichText(
                                                                                                      text: TextSpan(children: [
                                                                                                    if (state.selectedPost!.comments[reversedIndex2].commentUser.isFaculty) TextSpan(text: "[A] ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.normal, fontSize: textSize * 1.2)),
                                                                                                    TextSpan(text: state.selectedPost!.comments[reversedIndex2].commentUser.displayName.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: textSize * 1.2)),
                                                                                                    TextSpan(text: "  ${DateFormat('MM-dd-yyyy hh:mm a').format(state.selectedPost!.comments[reversedIndex2].commentedTime)}", style: TextStyle(color: Colors.grey, fontSize: textSize))
                                                                                                  ])),
                                                                                                  subtitle: Text(state.selectedPost!.comments[reversedIndex2].contents, style: TextStyle(fontSize: textSize)),
                                                                                                  trailing: PopupMenuButton(
                                                                                                    iconSize: textSize * 1.5,
                                                                                                    onSelected: ((value) {
                                                                                                      if (value == '/edit') {
                                                                                                        showDialog(
                                                                                                          barrierDismissible: true,
                                                                                                          context: context,
                                                                                                          builder: (_) {
                                                                                                            return BlocProvider.value(
                                                                                                              value: BlocProvider.of<SpaceBloc>(context),
                                                                                                              child: EditMessagePopUp(
                                                                                                                post: state.selectedPost!.comments[reversedIndex2],
                                                                                                              ),
                                                                                                            );
                                                                                                          },
                                                                                                        );
                                                                                                      } else if (value == '/delete') {
                                                                                                        context.read<SpaceBloc>().add(RemoveComment(selectedComment: state.selectedPost!.comments[reversedIndex2]));
                                                                                                      }
                                                                                                    }),
                                                                                                    itemBuilder: (context) {
                                                                                                      if (state.deletePostStatus is DataRetrieving) {
                                                                                                        return const [
                                                                                                          PopupMenuItem(child: CircularProgressIndicator())
                                                                                                        ];
                                                                                                      } else {
                                                                                                        if (state.currentUser.uid == state.selectedPost!.comments[reversedIndex2].commentUser.uid || (state.permissions!.canRemove && state.permissions!.canEdit)) {
                                                                                                          return const [
                                                                                                            PopupMenuItem(value: '/edit', child: Text("Edit")),
                                                                                                            PopupMenuItem(value: '/delete', child: Text("Delete"))
                                                                                                          ];
                                                                                                        } else if (state.permissions!.canRemove) {
                                                                                                          return const [
                                                                                                            PopupMenuItem(value: '/delete', child: Text("Delete")),
                                                                                                          ];
                                                                                                        } else if (state.permissions!.canEdit) {
                                                                                                          return const [
                                                                                                            PopupMenuItem(value: '/edit', child: Text("Edit")),
                                                                                                          ];
                                                                                                        } else {
                                                                                                          return const [
                                                                                                            PopupMenuItem(child: const SizedBox.shrink())
                                                                                                          ];
                                                                                                        }
                                                                                                      }
                                                                                                    },
                                                                                                  ),
                                                                                                ));
                                                                                          })
                                                                                    ] else if (state.getCommentsStatus is RetrievalFailed) ...[
                                                                                      const Center(child: Text("Error with Data Retrieval. Please Refresh."))
                                                                                    ] else ...[
                                                                                      const SizedBox(
                                                                                          width: 300,
                                                                                          height: 100,
                                                                                          child: Text(
                                                                                            "Else Block",
                                                                                            style: TextStyle(color: Colors.blue, fontSize: 40),
                                                                                          ))
                                                                                    ],
                                                                                  ],
                                                                                );
                                                                              } else {
                                                                                return Center(child: SizedBox(width: textSize * 5, height: textSize * 5, child: const CircularProgressIndicator()));
                                                                              }
                                                                            }
                                                                                // ]
                                                                                ))),
                                                                    Material(
                                                                        elevation:
                                                                            2,
                                                                        color: Colors
                                                                            .white,
                                                                        child: Container(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 5),
                                                                            child: _createCommentForm())),
                                                                  ],
                                                                )),
                                                          ],
                                                        )));
                                              }));
                                        }));
                              });

                          // Show error message when Retrieval fails
                        } else if (state.getPostsStatus is RetrievalFailed) {
                          return const Center(
                              child: Text(
                                  "Error with Data Retrieval. Please Refresh."));
                          // Initial Data Retrieval Status
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                    )),
              ),
              Material(
                elevation: 2,
                color: Colors.white,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    color: Colors.white,
                    child: _createPostForm()),
              )
            ]),
          );
        }));
  }

  Widget _createPostForm() {
    //_scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    return BlocListener<SpaceBloc, SpaceState>(
        listenWhen: (previous, current) {
          if (current.postFormStatus == previous.postFormStatus) {
            return false;
          } else {
            return true;
          }
        },
        listener: (context, state) {
          final formStatus = state.postFormStatus;
          if (formStatus is SubmissionFailed) {
            MiscWidgets.showException(context, formStatus.exception.toString());
          }
        },
        child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  _messageField(_formKey),
                  const SizedBox(width: 10),
                  _createPostButton(_formKey),
                ],
              ),
            )));
  }

  void scrollAnimateToEnd(ScrollController controller) {
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      try {
        controller
            .animateTo(
          controller.position.minScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        )
            .then((value) {
          controller.animateTo(
            controller.position.minScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        });
      } catch (e) {
        print('error on scroll $e');
      }
    });
  }

  Widget _messageField(GlobalKey<FormState> key) {
    return BlocBuilder<SpaceBloc, SpaceState>(builder: (context, state) {
      final Size screenSize = MediaQuery.of(context).size;
      final double imageWidth = screenSize.width * 0.7;
      final double imageHeight = screenSize.height * 0.4;
      final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
      final double textSize = screenSize.width <= 500 ? 12 : 20;
      final double postBoxConstraints = screenSize.width <= 500 ? 30 : 50;
      final double commentBoxConstraints = screenSize.width <= 500 ? 20 : 30;
      return Flexible(
        child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _postController,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: textSize * 0.9),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  hintText: 'Message ${widget.currentSpace.spaceName}',
                  hintStyle:
                      TextStyle(color: Colors.grey, fontSize: textSize * 0.9)),
              onChanged: (value) => context
                  .read<SpaceBloc>()
                  .add(PostMessageChanged(message: value)),
              onFieldSubmitted: (value) {
                if (key.currentState!.validate()) {
                  if (state.permissions!.canPost) {
                    context.read<SpaceBloc>().add(PostSubmitted());
                    _postController.clear();
                    scrollAnimateToEnd(_postScrollController);
                  } else {
                    MiscWidgets.showException(context,
                        "You do not have permission to do that. Please contact a Space Administrator.");
                  }
                }
              },
              validator: (value) {
                bool isValid = true;
                final filter = ProfanityFilter();
                if (value!.isEmpty) {
                  return "Please enter text.";
                }
                if (filter.hasProfanity(value)) {
                  return "Post must not contain profanity!";
                } else {
                  return null;
                }
              },
              maxLength: 500,
              maxLines: null,
            )),
      );
    });
  }

  Widget _createPostButton(GlobalKey<FormState> key) {
    return BlocBuilder<SpaceBloc, SpaceState>(builder: (context, state) {
      final Size screenSize = MediaQuery.of(context).size;
      final double imageWidth = screenSize.width * 0.7;
      final double imageHeight = screenSize.height * 0.4;
      final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
      final double textSize = screenSize.width <= 500 ? 12 : 20;
      final double postBoxConstraints = screenSize.width <= 500 ? 30 : 50;
      final double commentBoxConstraints = screenSize.width <= 500 ? 20 : 30;
      return state.postFormStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (key.currentState!.validate()) {
                  if (state.permissions!.canPost) {
                    context.read<SpaceBloc>().add(PostSubmitted());
                    _postController.clear();
                    scrollAnimateToEnd(_postScrollController);
                  } else {
                    MiscWidgets.showException(context,
                        "You do not have permission to do that. Please contact a Space Administrator.");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  side: const BorderSide(color: Colors.black, width: 0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              child: Text('Post',
                  style: TextStyle(
                      color: Colors.white, fontSize: textSize * 0.7)));
    });
  }

  Widget _createCommentForm() {
    final _formKey = GlobalKey<FormState>();
    return BlocListener<SpaceBloc, SpaceState>(
      listenWhen: (previous, current) {
        if (current.commentFormStatus == previous.commentFormStatus) {
          return false;
        } else {
          return true;
        }
      },
      listener: (context, state) {
        final formStatus = state.commentFormStatus;
        if (formStatus is SubmissionFailed) {
          MiscWidgets.showException((context), formStatus.exception.toString());
        } else if (formStatus is SubmissionSuccess) {
          MiscWidgets.showException(context, "COMMENT SUCCESS");
        }
      },
      child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                _commentField(_formKey),
                const SizedBox(width: 10),
                _createCommentButton(_formKey)
              ],
            ),
          )),
    );
  }

  Widget _commentField(GlobalKey<FormState> key) {
    return BlocBuilder<SpaceBloc, SpaceState>(builder: (context, state) {
      final Size screenSize = MediaQuery.of(context).size;
      final double imageWidth = screenSize.width * 0.7;
      final double imageHeight = screenSize.height * 0.4;
      final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
      final double textSize = screenSize.width <= 500 ? 12 : 20;
      final double postBoxConstraints = screenSize.width <= 500 ? 30 : 50;
      final double commentBoxConstraints = screenSize.width <= 500 ? 20 : 30;
      return Flexible(
          child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: TextFormField(
                controller: _commentController,
                style: TextStyle(color: Colors.black, fontSize: textSize * 0.9),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    hintText: 'Reply',
                    hintStyle: TextStyle(
                        color: Colors.grey, fontSize: textSize * 0.9)),
                onChanged: (value) => context
                    .read<SpaceBloc>()
                    .add(CommentMessageChanged(message: value)),
                onFieldSubmitted: (value) {
                  if (key.currentState!.validate()) {
                    if (state.permissions!.canPost) {
                      context.read<SpaceBloc>().add(CommentSubmitted());
                      _commentController.clear();
                      scrollAnimateToEnd(_commentScrollController);
                    } else {
                      MiscWidgets.showException(context,
                          "You do not have permission to do that. Please contact a Space Administrator.");
                    }
                  }
                },
                validator: (value) {
                  final filter = ProfanityFilter();
                  if (value!.isEmpty) {
                    return "Please enter text.";
                  }
                  if (filter.hasProfanity(value)) {
                    return "Post must not contain profanity!";
                  } else {
                    return null;
                  }
                },
                maxLength: 300,
              )));
    });
  }

  Widget _createCommentButton(GlobalKey<FormState> key) {
    return BlocBuilder<SpaceBloc, SpaceState>(builder: (context, state) {
      final Size screenSize = MediaQuery.of(context).size;
      final double imageWidth = screenSize.width * 0.7;
      final double imageHeight = screenSize.height * 0.4;
      final double textScaleFactor = screenSize.width <= 500 ? 3 : 5;
      final double textSize = screenSize.width <= 500 ? 12 : 20;
      final double postBoxConstraints = screenSize.width <= 500 ? 30 : 50;
      final double commentBoxConstraints = screenSize.width <= 500 ? 20 : 30;
      return state.commentFormStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (key.currentState!.validate()) {
                  if (state.permissions!.canComment) {
                    context.read<SpaceBloc>().add(CommentSubmitted());
                    _commentController.clear();
                    scrollAnimateToEnd(_commentScrollController);
                  } else {
                    MiscWidgets.showException(context,
                        "You do not have permission to do that. Please contact a Space Administrator.");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  side: const BorderSide(color: Colors.black, width: 0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              child: Text('Reply',
                  style: TextStyle(
                      color: Colors.white, fontSize: textSize * 0.7)));
    });
  }
}
