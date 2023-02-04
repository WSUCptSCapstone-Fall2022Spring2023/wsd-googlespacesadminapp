# Sprint 4 Report (12/9/2022 - 2/2023)

## What's New (User Facing)
* MVP Project Report Updates
* UI Updates
* Implemented view/edit profile feature
* Alpha prototype demo
* Working on chat within each Space
* Minor button fixes
* Other minor Flutter/dart files

## Work Summary (Developer Facing)
In this sprint, the team focused on UI updates and tweaks, implementing the edit profile feature, and working on a text chat within each Space. Along with edit profile, we have also implemented Admin User controls that will allow Admins to change Students profiles/chats. We have finished routing for the Spaces feature as well as updated the UI for better user readiness. We have also begun documenting our MVP Report for our Alpha Prototype followed by a live demo showcasing how the application functions. 

## Unfinished Work
The team is continuously working on UI changes and finishing the routing for the text chats in each Spaces. For now the text chat is an empty dummy function but will be completed towards the next sprint. We will also be updating the MVP Report and begin to prepare a printed poster presentation for our class and clients. 

## Completed Issue/User Stories
Here are links to the issues that we completed in this sprint:

## Incomplete Issues/ User Stories

## Code Files for Review
Please review the following important code files, which were actively developed/created during this sprint, for quality:
 * [pubspec.yaml]
 * [lib/main.dart]
 Business_Logic
 * [lib/business_logic/auth/login_event.dart]
 * [lib/business_logic/auth/login_state.dart]
 * [lib/business_logic/create_space]
 * [lib/business_logic/edit_profile/edit_space_bloc.dart]
 * [lib/business_logic/edit_profile/edit_space_event.dart]
  * [lib/business_logic/edit_profile/edit_space_state.dart]
 Data
 * [lib/data/repositories/userData_repository.dart]
 * [lib/data/models/permissionData.dart]
 * [lib/data/models/spaceData._dart]
 * [lib/data/repositories/auth_repository.dart]
 * [lib/data/repositories/space_repository.dart]
 * [lib/data/repositories/userData_repository.dart]
 Presentation
 * [lib/presentation/views/edit_profileView.dart]
 * [lib/presentation/views/homeView.dart]
 * [lib/presentation/views/loginView.dart]
 * [lib/presentation/views/profileView.dart]
 * [lib/presentation/views/settingsView.dart]
 * [lib/presentation/views/spaceView.dart]
 * [lib/presentation/widgets/createSpaceButtonSheet.dart]
 * [lib/presentation/widgets/createStudentButtonSheet.dart]
 * [lib/presentation/widgets/helpBottomSheet.dart]
 * [lib/presentation/widgets/navigation_drawer.dart]
 Test
 * [test/login/login_event_test.dart]
 * [test/login/login_state_test.dart]

## Retrospective Summary
Here's what went well:
 * Rigorous note-taking
 * Problem solving when running into difficult challenges
 * High-Quality document revision
 * Meeting deadlines

Here's what we'd like to improve:
 * Team-Client meetings
 * Communicating with Client
 * The splitting of the workload
 * Using time effectively and spreading worktimes apart throughout the Sprint instead of cramming

Here are changes we plan to implement in the next sprint:
 * Edit User Account Information
 * Creating, Opening, Editing, Commenting on, and Deleting Post Spaces
 * Creating, Opening, Editing, Commenting on, and Deleting Posts
 * Creating, Opening, Editing, Commenting to, and Deleting Comments
 * UI Changes
 * Admin User Controls
 * User Text Chat
 * Unit Tests