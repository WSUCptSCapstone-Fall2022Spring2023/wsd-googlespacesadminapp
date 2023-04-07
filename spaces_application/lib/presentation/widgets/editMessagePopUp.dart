import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:spaces_application/data/models/commentData.dart';
import 'package:spaces_application/data/models/postData.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';
import '../../business_logic/space/space_bloc.dart';
import '../../business_logic/space/space_event.dart';
import '../../business_logic/space/space_state.dart';
import '../../data/models/spaceData.dart';

class EditMessagePopUp extends StatefulWidget {
  EditMessagePopUp({required this.post});
  final post;

  @override
  _EditMessagePopUpState createState() => _EditMessagePopUpState(post);
}

class _EditMessagePopUpState extends State<EditMessagePopUp> {
  _EditMessagePopUpState(this.post);
  final post;
  TextEditingController _controller = TextEditingController();
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.post.contents);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 200, vertical: 320),
        backgroundColor: Colors.white,
        child: Stack(alignment: Alignment.center, children: <Widget>[
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.black, size: 25),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Edit Message",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 35))),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(height: 0),
                  ),
                  _editCommentForm(context, widget.post.contents),
                ],
              )),
        ]));
  }

  Widget _editCommentForm(BuildContext context, String previousMessage) {
    final _formKey = GlobalKey<FormState>();
    return BlocListener<SpaceBloc, SpaceState>(
      listenWhen: (previous, current) {
        if (current.editPostFormStatus == previous.editPostFormStatus &&
            current.editCommentFormStatus == previous.editCommentFormStatus) {
          return false;
        } else {
          return true;
        }
      },
      listener: (context, state) {
        final formStatus;
        if (post is PostData) {
          formStatus = state.editPostFormStatus;
        } else {
          formStatus = state.editCommentFormStatus;
        }
        if (formStatus is SubmissionFailed) {
          MiscWidgets.showException((context), formStatus.exception.toString());
        } else if (formStatus is SubmissionSuccess) {
          Navigator.pop(context);
        }
      },
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _messageField(),
              const SizedBox(height: 10),
              Row(
                children: [
                  _cancelButton(),
                  const SizedBox(width: 10),
                  _editCommentButton(_formKey)
                ],
              )
            ],
          )),
    );
  }

  Widget _messageField() {
    return BlocBuilder<SpaceBloc, SpaceState>(builder: (context, state) {
      return Flexible(
          child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: TextFormField(
                controller: _controller,
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                    hintText: widget.post.contents,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 18)),
                onChanged: (value) => context
                    .read<SpaceBloc>()
                    .add(EditFieldChanged(message: value)),
                onFieldSubmitted: (value) => context
                    .read<SpaceBloc>()
                    .add(EditFieldChanged(message: value)),
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

  Widget _cancelButton() {
    return ElevatedButton(
      onPressed: (() {
        Navigator.pop(context);
      }),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        side: const BorderSide(color: Colors.black, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: const Text("Cancel",
          style: TextStyle(color: Colors.black, fontSize: 13)),
    );
  }

  Widget _editCommentButton(GlobalKey<FormState> key) {
    return BlocBuilder<SpaceBloc, SpaceState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            if (key.currentState!.validate()) {
              if (post is PostData) {
                context.read<SpaceBloc>().add(EditPost(
                    newContents: state.newEditContents, selectedPost: post));
              } else if (post is CommentData) {
                context.read<SpaceBloc>().add(EditComment(
                    newContents: state.newEditContents, selectedComment: post));
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.black, width: 0.5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: const Text('Save Edit',
              style: TextStyle(color: Colors.black, fontSize: 13)),
        );
      },
    );
  }
}
