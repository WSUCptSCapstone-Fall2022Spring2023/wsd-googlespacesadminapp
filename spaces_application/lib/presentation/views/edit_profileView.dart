import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';
import '../../business_logic/edit_profile/edit_space_bloc.dart';
import '../../business_logic/edit_profile/edit_space_event.dart';
import '../../business_logic/edit_profile/edit_space_state.dart';
import '../../data/models/userData.dart';
import '../../data/repositories/userData_repository.dart';
import '../widgets/navigation_drawer.dart';
import 'package:fluttermoji/fluttermoji.dart';

class EditProfileView extends StatefulWidget {
  EditProfileView({this.title}) : super();
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EditProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        centerTitle: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Use your Fluttermoji anywhere\nwith the below widget",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          FluttermojiCircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 100,
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "and create your own page to customize them using our widgets",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Spacer(flex: 2),
              Expanded(
                flex: 3,
                child: Container(
                  height: 35,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text("Customize"),
                    onPressed: () => Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => NewPage())),
                  ),
                ),
              ),
              Spacer(flex: 2),
            ],
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: FluttermojiCircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              SizedBox(
                width: 600,
                child: Row(
                  children: [
                    Text(
                      "Customize:",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Spacer(),
                    FluttermojiSaveWidget(),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                child: FluttermojiCustomizer(
                  scaffoldWidth: 600,
                  autosave: false,
                  theme: FluttermojiThemeData(
                      boxDecoration: BoxDecoration(boxShadow: [BoxShadow()])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class EditProfileView extends StatelessWidget {
//   EditProfileView({required this.currentUserData});
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final Color bgColor = Color.fromARGB(255, 12, 12, 12);
//   final Color textColor = const Color.fromARGB(255, 14, 4, 104);
//   final Color boxColor = Color.fromARGB(255, 60, 60, 60);
//   final Color navyBlue = const Color.fromARGB(255, 14, 4, 104);
//   final Color salmon = const Color.fromARGB(255, 252, 117, 106);

//   final UserData currentUserData;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       drawer: NavigationDrawer(
//         currentUserData: currentUserData,
//       ),
//       appBar: AppBar(
//         elevation: 15,
//         title: const Text("Your Profile Page"),
//         backgroundColor: navyBlue,
//       ),
//       body: Column(
//         children: <Widget>[
//           FluttermojiCircleAvatar(),
//           Container(
//               constraints: BoxConstraints(maxHeight: 400, maxWidth: 700),
//               child: FluttermojiCustomizer()),
//           const SizedBox(height: 15),
//           Text("${currentUserData.firstName} ${currentUserData.lastName}",
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                   color: Colors.black, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),
//           Text(currentUserData.email,
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.black)),
//           const SizedBox(height: 10),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Divider(height: 0),
//           ),
//           BlocProvider(
//             create: (context) => EditProfileBloc(
//               userRepo: context.read<UserDataRepository>(),
//             ),
//             child: _createSpaceForm(),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _createSpaceForm() {
//     return BlocListener<EditProfileBloc, EditProfileState>(
//         listenWhen: (previous, current) {
//           if (current.formStatus == previous.formStatus)
//             return false;
//           else
//             return true;
//         },
//         listener: (context, state) {
//           final formStatus = state.formStatus;
//           if (formStatus is SubmissionFailed) {
//             MiscWidgets.showException(context, formStatus.exception.toString());
//           } else if (formStatus is SubmissionSuccess) {
//             // Navigate to new page
//             context.read<UserDataRepository>().getCurrentUserData();
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(
//                 builder: (context) => HomeView(
//                   currentUserData: currentUserData,
//                 ),
//               ),
//             );
//             MiscWidgets.showException(context, "SPACE CREATION SUCCESS");
//           }
//         },
//         child: Container(
//             alignment: Alignment.topCenter,
//             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
//             child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(width: 2, color: salmon),
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(40.0),
//                       bottomRight: Radius.circular(40.0),
//                       topLeft: Radius.circular(40.0),
//                       bottomLeft: Radius.circular(40.0)),
//                 ),
//                 child: Form(
//                     key: _formKey,
//                     child: Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             _firstNameField(currentUserData),
//                             _lastNameField(currentUserData),
//                             _displayNameField(currentUserData),
//                             _emailField(currentUserData),
//                             _parentEmailField(currentUserData),
//                             Padding(
//                                 padding: EdgeInsets.only(top: 5),
//                                 child: _editProfileButton()),
//                           ],
//                         ))))));
//   }

//   Widget _firstNameField(UserData currentUser) {
//     return BlocBuilder<EditProfileBloc, EditProfileState>(
//         builder: (context, state) {
//       return TextFormField(
//         initialValue: currentUser.firstName,
//         readOnly: !(currentUser.isFaculty),
//         style: TextStyle(color: textColor),
//         decoration: InputDecoration(
//             enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: textColor, width: 0.0)),
//             hintText: "First Name",
//             hintStyle: TextStyle(color: navyBlue)),
//         validator: (value) =>
//             state.isValidFirstName ? null : 'Must be between 2 - 20 characters',
//         onChanged: (value) => context
//             .read<EditProfileBloc>()
//             .add(ProfileFirstNameChanged(firstName: value)),
//       );
//     });
//   }

//   Widget _lastNameField(UserData currentUser) {
//     return BlocBuilder<EditProfileBloc, EditProfileState>(
//         builder: (context, state) {
//       return TextFormField(
//         initialValue: currentUser.lastName,
//         readOnly: !(currentUser.isFaculty),
//         style: TextStyle(color: textColor),
//         decoration: InputDecoration(
//             enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: textColor, width: 0.0)),
//             hintText: "Last Name",
//             hintStyle: TextStyle(color: textColor)),
//         validator: (value) =>
//             state.isValidLastName ? null : 'Must be between 2 - 20 characters',
//         onChanged: (value) => context
//             .read<EditProfileBloc>()
//             .add(ProfileLastNameChanged(lastName: value)),
//       );
//     });
//   }

//   Widget _emailField(UserData currentUser) {
//     return BlocBuilder<EditProfileBloc, EditProfileState>(
//         builder: (context, state) {
//       return TextFormField(
//         initialValue: currentUser.email,
//         readOnly: true,
//         style: TextStyle(color: textColor),
//         decoration: InputDecoration(
//             enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: textColor, width: 0.0)),
//             hintText: "Email",
//             hintStyle: TextStyle(color: textColor)),
//       );
//     });
//   }

//   Widget _displayNameField(UserData currentUser) {
//     return BlocBuilder<EditProfileBloc, EditProfileState>(
//         builder: (context, state) {
//       return TextFormField(
//         initialValue: currentUser.displayName,
//         style: TextStyle(color: textColor),
//         decoration: InputDecoration(
//             enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: textColor, width: 0.0)),
//             hintText: "Display Name",
//             hintStyle: TextStyle(color: textColor)),
//         validator: (value) => state.isValidDisplayName
//             ? null
//             : 'Must be between 2 - 25 characters',
//         onChanged: (value) => context
//             .read<EditProfileBloc>()
//             .add(ProfileDisplayNameChanged(displayName: value)),
//       );
//     });
//   }

//   Widget _parentEmailField(UserData currentUser) {
//     return BlocBuilder<EditProfileBloc, EditProfileState>(
//         builder: (context, state) {
//       return TextFormField(
//         initialValue: currentUser.isFaculty ? "N/A" : currentUser.parentEmail,
//         readOnly: true,
//         style: TextStyle(color: textColor),
//         decoration: InputDecoration(
//             enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: textColor, width: 0.0)),
//             hintText: "Parent Email",
//             hintStyle: TextStyle(color: textColor)),
//       );
//     });
//   }

//   Widget _editProfileButton() {
//     return BlocBuilder<EditProfileBloc, EditProfileState>(
//         builder: (context, state) {
//       return state.formStatus is FormSubmitting
//           ? CircularProgressIndicator()
//           : ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   context.read<EditProfileBloc>().add(ProfileSubmitted());
//                 }
//               },
//               child: Text('Submit  Profile'),
//               style: ElevatedButton.styleFrom());
//     });
//   }
// }