import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';
import '../../business_logic/space/space_bloc.dart';
import '../../business_logic/space/space_event.dart';
import '../../business_logic/space/space_state.dart';
import '../../data/models/spaceData.dart';

class EditMessagePopUp extends StatefulWidget {
  EditMessagePopUp({required this.previousMessage});
  final String previousMessage;

  @override
  _EditMessagePopUpState createState() => _EditMessagePopUpState();
}

class _EditMessagePopUpState extends State<EditMessagePopUp> {
  TextEditingController _controller = TextEditingController();
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.previousMessage);
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
            const EdgeInsets.symmetric(horizontal: 250, vertical: 350),
        backgroundColor: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black, size: 25),
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
            // TODO: Add BlocProvider here, which will hold the message form

            _editCommentForm(context, widget.previousMessage),
          ],
        ));
  }

  Widget _editCommentForm(BuildContext context, String previousMessage) {
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
          MiscWidgets.showException(context, "Edit Message SUCCESS(?)");
        }
      },
      child: Form(
          key: _formKey,
          child: Column(
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter text, or press cancel to cancle edit.';
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                    hintText: widget.previousMessage,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 18)),
                onChanged: (value) => context
                    .read<SpaceBloc>()
                    .add(CommentMessageChanged(message: value)),
                onFieldSubmitted: (value) => context
                    .read<SpaceBloc>()
                    .add(CommentMessageChanged(message: value)),
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
    return ElevatedButton(
      onPressed: () {
        if (key.currentState!.validate()) {
          // TODO: Finish implementation of editing a comment.
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        side: const BorderSide(color: Colors.black, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: const Text('Edit',
          style: TextStyle(color: Colors.black, fontSize: 13)),
    );
  }
}
