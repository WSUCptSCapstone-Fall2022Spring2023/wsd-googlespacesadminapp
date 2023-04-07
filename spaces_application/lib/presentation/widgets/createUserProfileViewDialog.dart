// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttermoji/fluttermoji.dart';
// import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
// import 'package:spaces_application/data/models/userData.dart';
// import 'package:spaces_application/presentation/widgets/createSpacePopUpDialog.dart';
// import 'package:spaces_application/presentation/views/loginView.dart';
// import 'package:spaces_application/presentation/views/homeView.dart';
// import 'package:spaces_application/presentation/widgets/helpPopUpDialog.dart';
// import 'package:spaces_application/presentation/widgets/createStudentPopUpDialog.dart';
// import 'package:spaces_application/presentation/widgets/miscWidgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_svg/flutter_svg.dart';
// import '../../data/models/spaceData.dart';
// import '../../data/repositories/userData_repository.dart';
// import '../views/edit_profileView.dart';
// import '../views/spaceView.dart';
// import 'dart:math';

// import 'package:path/path.dart';

// class CreateUserProfileViewDialog extends StatelessWidget {
//   CreateUserProfileViewDialog(
//       {required this.currentSpace,
//       required this.currentUserData,
//       required this.selectedUserData});
//   SpaceData? currentSpace;
//   final UserData currentUserData;
//   final UserData selectedUserData;
//   static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final Color darkViolet = Color.fromARGB(255, 9, 5, 5);
//   final Color navyBlue = Color.fromARGB(255, 14, 4, 104);
//   final Color picoteeBlue = Color.fromARGB(255, 45, 40, 208);
//   final Color majorelleBlue = Color.fromARGB(255, 86, 85, 221);
//   final Color salmon = Color.fromARGB(255, 252, 117, 106);
//   final Color phthaloBlue = Color.fromARGB(255, 22, 12, 120);
//   final Color lightPink = Color.fromARGB(255, 243, 171, 174);
//   final Color offWhite = Color.fromARGB(255, 255, 255, 240);

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//         insetPadding:
//             const EdgeInsets.symmetric(horizontal: 150, vertical: 250),
//         backgroundColor: Colors.white,
//         child: Stack(
//           alignment: Alignment.topLeft,
//           children: [
//             Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     Align(
//                         alignment: Alignment.topRight,
//                         child: IconButton(
//                           icon: const Icon(Icons.close,
//                               color: Colors.black, size: 25),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         )),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: FluttermojiCircleAvatar(
//                         radius: 100,
//                         backgroundColor: Colors.grey[200],
//                       ),
//                     ),
//                     if (currentUserData.isFaculty)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(currentUserData.email,
//                               style: const TextStyle(
//                                   color: Colors.black, fontSize: 22)),
//                           const Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 12),
//                               child: Icon(Icons.circle,
//                                   color: Colors.red, size: 12)),
//                           const Text("Faculty User",
//                               style:
//                                   TextStyle(color: Colors.black, fontSize: 22)),
//                         ],
//                       ),
//                     if (currentUserData.isFaculty == false)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                               '${currentUserData.firstName} ${currentUserData.lastName}',
//                               style: const TextStyle(
//                                   color: Colors.black, fontSize: 22)),
//                           const Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 12),
//                               child: Icon(Icons.circle,
//                                   color: Colors.red, size: 12)),
//                           Text(currentUserData.email,
//                               style: const TextStyle(
//                                   color: Colors.black, fontSize: 22)),
//                           const Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 12),
//                               child: Icon(Icons.circle,
//                                   color: Colors.red, size: 12)),
//                           Text(currentUserData.parentEmail,
//                               style: const TextStyle(
//                                   color: Colors.black, fontSize: 22)),
//                         ],
//                       ),
//                     if (currentUserData.isFaculty == false)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Text("Student User",
//                               style:
//                                   TextStyle(color: Colors.black, fontSize: 22)),
//                         ],
//                       ),
//                     const SizedBox(height: 20),
//                     const Text("Contact"),
//                     const SizedBox(height: 10),
//                     Text(currentUserData.email),
//                     const SizedBox(height: 20),
//                     const Text("Biography"),
//                     const SizedBox(height: 10),
//                     Text(
//                         "${currentUserData.firstName} ${currentUserData.lastName} has not added a bio."),
//                     const SizedBox(height: 120),
//                   ],
//                 )),
//           ],
//         ));
//   }
// }
