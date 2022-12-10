# Sprint 3 Report (11/10/2022 - 12/9/2022)

## What's New (User Facing)
* Proto Project Report - Draft and Final
* In-class Presentation and Demo
* Client Prototype Demo
* Home page integration
* Other minor Flutter/dart files

## Work Smmary (Developer Facing)
In this sprint, the team focused on configuring Post Spaces, creating a home landing page, and creating unit tests to verify proper processes and outcomes of the application. We have successfully configured the Firebase database for Pose Spaces which will allow a user to create Post Space with a title and description to commment, edit and collaborate. We have also successfuly implemented the Wahkiakhum website home page into our application's landing page. To verify the integrity of our application, we also have created unit tests for the Business_Logic login files. We are in optimal position to continue our work and prepare a prototype for presentation by early February.

## Unfinished Work
Although the Firebase database has been setup for the Post Spaces feature, we still need to emit the state to our Presentation section of our application and will be continuing to implement this over break. We will also be working on the Administrative account features and implementation as well as polishing the unit tests for the application. 

## Completed Issue/User Stories
Here are links to the issues that we completed in this sprint:

## Incomplete Issues/ User Stories

## Code Files for Review
Please review the following important code files, which were actively developed/created during this sprint, for quality:
 * [pubspec.yaml]
 Business_Logic
 * [lib/business_logic/data_retrieval_status.dart]
 * [lib/business_logic/create_space/create_space_bloc.dart]
 * [lib/business_logic/create_space/create_space_event.dart]
 * [lib/business_logic/create_space/create_space_state.dart]
 * [lib/business_logic/home/home_bloc.dart]
 * [lib/business_logic/home/home_event.dart]
 * [lib/business_logic/home/home_state.dart]
 Data
 * [lib/data/repositories/userData_repository.dart]
 * [lib/data/models/permissionData.dart]
 * [lib/data/models/spaceData.dart]
 Presentation
 * [lib/presentation/views/spaceView.dart]
 Test
 * [test/login/login_bloc_test.dart]
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
 * The splitting of the workload
 * Using time effectively and spreading worktimes apart throughout the Sprint instead of cramming

Here are changes we plan to implement in the next sprint:
 * User Types
 * Edit User Account Information
 * Delete User Account
 * Creating, Opening, Editing, Commenting on, and Deleting Post Spaces
 * Creating, Opening, Editing, Commenting on, and Deleting Posts
 * Creating, Opening, Editing, Commenting to, and Deleting Comments
 * Unit Tests