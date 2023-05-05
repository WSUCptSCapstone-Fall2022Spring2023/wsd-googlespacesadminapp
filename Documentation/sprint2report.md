# Sprint 2 Report (10/10/2022 - 11/9/2022) 

## What's New (User Facing)
 * Testing and Acceptance document
 * Major Code sections, including the Business_Logic, Data, and Presentation sections
 * Other minor Flutter/dart files

## Work Summary (Developer Facing)
During this sprint, the team was focused mostly on the development of the integral foundations of the application. We set up the general Flutter/Bloc foundation, and created the Login and Home pages, creating using Flutter Widgets. With these UI Pages, we connected them with routing, to allow going from page to page. Finally, we initialized the Firebase database, and connected it to the application, adding functionality to create and test accounts. Overall, we are very happy with the progress made on the application during the sprint. We have a base UI style to create other pages upon, and have routing and database use figured out, putting us in a great position to make great progress on our next Sprint.

## Unfinished Work
Our team initially hoped to implement Post Spaces. After working on the application, we figured it made more sense to save that for the next Sprint, as this Sprint was focused on implementing a base UI, connecting it with Business Logic, to the Firebase Database, and creating functioning Routes. We are planning on implementing Post Spaces during Sprint 3.

## Completed Issue/User Stories
Here are links to the issues that we completed in this sprint:

 * https://github.com/WSUCptSCapstone-Fall2022Spring2023/wsd-googlespacesadminapp/issues/14
 * https://github.com/WSUCptSCapstone-Fall2022Spring2023/wsd-googlespacesadminapp/issues/15
 * https://github.com/WSUCptSCapstone-Fall2022Spring2023/wsd-googlespacesadminapp/issues/22
 * https://github.com/WSUCptSCapstone-Fall2022Spring2023/wsd-googlespacesadminapp/issues/23
 * https://github.com/WSUCptSCapstone-Fall2022Spring2023/wsd-googlespacesadminapp/issues/24

## Incomplete Issues/User Stories
There are no incomplete issues for Sprint 2.

## Code Files for Review
Please review the following important code files, which were actively developed/created during this sprint, for quality:
 * [pubspec.yaml]
 * Business Logic
 * [lib/business_logic/auth/login/login_bloc.dart]
 * [lib/business_logic/auth/login/login_event.dart]
 * [lib/business_logic/auth/login/login_state.dart]
 * [lib/business_logic/auth/register/register_bloc.dart]
 * [lib/business_logic/auth/register/register_event.dart]
 * [lib/business_logic/auth/register/register_state.dart]
 * [lib/business_logic/auth/form_submission_status.dart]
 * Data
 * [lib/data/repositories/auth_repository.dart]
 * Presentation
 * [lib/presentation/views/homeView.dart]
 * [lib/presentation/views/loginView.dart]
 * [lib/presentaiton/views/registerView.dart]
 * [lib/presentaiton/widgets/main_menu_widget.dart]
 * [lib/presentaiton/widgets/miscWidgets.dart]
 * [lib/presentaiton/widgets/navigation_drawer]
 * [lib/presentation/main.dart]
 * Documentation
 * [Testing_and_Acceptance_plans.docx.pdf]

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
 * User Types
 * Edit User Account Information
 * Delete User Account
 * Creating, Opening, Editing, Commenting on, and Deleting Post Spaces
 * Creating, Opening, Editing, Commenting on, and Deleting Posts
 * Creating, Opening, Editing, Commenting to, and Deleting Comments