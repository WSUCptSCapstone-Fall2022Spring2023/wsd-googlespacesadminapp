# Sprint 6 Report (3/2/2023 - 4/2/2023)

## What's New (User Facing)
* MVP Project Report Updates
* Front-end improvement
* Editing and deleting comments in Spaces
* Comments views
* Admin control settings
* Space settings
* User settings
* IOS/MACOS Configuration

## Work Summary (Developer Facing)
In this sprint, the team has made significant progress UI improvements, Spaces settings, comments functionality, Admin control settings and IOS/MACOS Configurations. In Spaces, we implemented a Space menu so if you click on a user, you can see their profile information. In this view, this is also where permissions can be modified. Admin and Faculty users are now able to delete Spaces, and they are the only ones allowed to do so. The application has been configured to work on IOS and MacOS devices, but will still need some work if we continue to develop for multiple platforms. So far we have opted to developing the application to be a web app for easier access across all devices. Also, comments can now be edited and deleted in a Space. The team has implemented a search function for other users to be invited to a Space.

## Unfinished Work
Next, we will be focusing on optimizing the comments UI, deployment and completing the team Poster and Abstract.


## Completed Issue/User Stories
Here are links to the issues that we completed in this sprint:

## Incomplete Issues/ User Stories
* MVP document work
* Comments UI
* Poster work

## Code Files for Review
Please review the following important code files, which were actively developed/created during this sprint, for quality:
 * [pubspec.yaml]
 * [lib/main.dart]
 * Business_Logic
 * [lib/business_logic/space/space_bloc.dart]
 * [lib/business_logic/space/space_event.dart]
 * [lib/business_logic/space/space_state.dart]
 * Data
 * [lib/data/models/commentData._dart]
 * [lib/data/models/postData._dart]
 * [lib/data/repositories/space_repository.dart]
 * [lib/data/repositories/userData_repository.dart]
 * Presentation
 * [lib/presentation/views/editSettingsView.dart]
 * [lib/presentation/views/edit_profileView.dart]
 * [lib/presentation/views/homeView.dart]
 * [lib/presentation/views/profileView.dart]
 * [lib/presentation/views/settingsView.dart]
 * [lib/presentation/views/spaceView.dart] 
 * [lib/presentation/widgets/confirmInviteUsersPopUp.dart]
 * [lib/presentation/widgets/createAppBar.dart]
 * [lib/presentation/widgets/createCommentPopUpDialog.dart]
 * [lib/presentation/widgets/createInviteUserPopupDialog.dart]
 * [lib/presentation/widgets/createSpaceBottomSheet.dart]
 * [lib/presentation/widgets/createStudentBottomSheet.dart]
 * [lib/presentation/widgets/createUserProfileViewDialog.dart]
 * [lib/presentation/widgets/deleteSpacePopupDialog.dart]
 * [lib/presentation/widgets/editMessagePopUp.dart]
 * [lib/presentation/widgets/helpBottomSheet.dart]
 * [lib/presentation/widgets/navigation_drawer.dart]
 * [lib/presentation/widgets/settingsDrawer.dart]

## Retrospective Summary
Here's what went well:
 * Rigorous note-taking
 * Problem solving when running into difficult challenges
 * High-Quality document revision
 * Meeting deadlines

Here's what we'd like to improve:
 * Team-Client meetings
 * The splitting of the workload
 * Using time effectively and spreading worktimes apart throughout the Sprint instead of cramming

Here are changes we plan to implement in the next sprint:
 * UI Changes
 * Admin User Controls
 * Poster 
 * Deployment