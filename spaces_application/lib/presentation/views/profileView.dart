import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaces_application/presentation/views/edit_profileView.dart';
import 'package:spaces_application/presentation/views/homeView.dart';
import 'package:spaces_application/presentation/views/settingsView.dart';
import 'package:spaces_application/presentation/widgets/miscWidgets.dart';

import '../../business_logic/auth/form_submission_status.dart';
import '../../business_logic/edit_profile/edit_space_bloc.dart';
import '../../business_logic/edit_profile/edit_space_event.dart';
import '../../business_logic/edit_profile/edit_space_state.dart';
import '../../data/models/userData.dart';
import '../../data/repositories/userData_repository.dart';
import '../widgets/navigation_drawer.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  ProfileView({required this.currentUserData});
  final UserData currentUserData;
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color textColor = const Color.fromARGB(255, 246, 246, 176);
  final Color bgColor = const Color.fromARGB(255, 49, 49, 49);
  final Color boxColor = const Color.fromARGB(255, 60, 60, 60);
  final Color darkViolet = const Color.fromARGB(255, 9, 5, 5);
  final Color navyBlue = const Color.fromARGB(255, 14, 4, 104);
  final Color picoteeBlue = const Color.fromARGB(255, 45, 40, 138);
  final Color majorelleBlue = const Color.fromARGB(255, 86, 85, 221);
  final Color salmon = const Color.fromARGB(255, 252, 117, 106);
  final Color phthaloBlue = const Color.fromARGB(255, 22, 12, 113);
  final Color lightPink = const Color.fromARGB(255, 243, 171, 174);
  final Color offWhite = const Color.fromARGB(255, 244, 244, 244);

  final FluttermojiFunctions functions = FluttermojiFunctions();
  final FluttermojiController controller = FluttermojiController();

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    Get.put(FluttermojiController());
    return Scaffold(
      backgroundColor: offWhite,
      drawer: NavigationDrawer(
        currentUserData: currentUserData,
      ),
      appBar: AppBar(
        elevation: 15,
        // title: Text(currentSpace.spaceName,
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        backgroundColor: bgColor,
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
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FluttermojiCircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              if (currentUserData.isFaculty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(currentUserData.email,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 22)),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.circle, color: Colors.red, size: 12)),
                    const Text("Faculty User",
                        style: TextStyle(color: Colors.black, fontSize: 22)),
                  ],
                ),
              if (currentUserData.isFaculty == false)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        '${currentUserData.firstName} ${currentUserData.lastName}',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 22)),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.circle, color: Colors.red, size: 12)),
                    Text(currentUserData.email,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 22)),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.circle, color: Colors.red, size: 12)),
                    Text(currentUserData.parentEmail,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 22)),
                  ],
                ),
              if (currentUserData.isFaculty == false)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Student User",
                        style: TextStyle(color: Colors.black, fontSize: 22)),
                  ],
                ),
              const SizedBox(height: 20),
              const Text("Contact"),
              const SizedBox(height: 10),
              Text(currentUserData.email),
              const SizedBox(height: 20),
              const Text("Biography"),
              const SizedBox(height: 10),
              Text(
                  "${currentUserData.firstName} ${currentUserData.lastName} has not added a bio."),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black, width: 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => EditProfileView(
                      currentUserData: currentUserData,
                    ),
                  ));
                },
                child: const Text("Edit Profile",
                    style: TextStyle(color: Colors.black, fontSize: 18)),
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
//             child: _editProfilePictureForm(),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _editProfilePictureForm() {
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