# Experiment 9: Firestore Task Updates

## Simple idea
Create tasks and partially update their completion state.

## Aim

To develop a Flutter application demonstrating firestore task updates.

## Description (12 points)

1. The application creates tasks and updates existing Firestore documents. It demonstrates multi-field editing and partial progress updates in the same task list.

2. The task form accepts a title and assignee. Both values are required before the application creates a new record.

3. A new task stores its title, assignee, zero progress and Pending status. The updatedAt field receives a server timestamp.

4. StreamBuilder listens to task documents and refreshes the list when cloud data changes. Loading, database-error and empty-result states have visible messages.

5. Each task card displays its title, assignee, status and progress percentage. This makes the values being updated visible during the demonstration.

6. A slider changes progress between zero and one hundred in steps of ten. The chosen value is written back to the same task document.

7. The update method changes progress, status and modification time while preserving the title and assignee. This is a partial document update.

8. The status becomes Pending at zero, In progress between the boundaries, and Completed at one hundred. A dropdown filters the displayed tasks by these states.

9. The Edit details button opens a dialog containing the current title and assignee. Saving updates those fields together; empty fields are not accepted.

10. Cancel closes the edit dialog without writing changes. The Delete button removes the selected task from Firestore.

11. Operations display errors and disable action buttons while busy. A server timestamp records each successful modification rather than relying only on the local computer clock.

12. Configure Firebase, create a task and test zero, intermediate and full progress. Edit its title, cancel another edit, filter by status and delete it while verifying the corresponding cloud document.

## Run in Chrome on Windows or Linux

Install Flutter and Chrome on either OS. These Firebase samples target the browser; they do not claim native Linux Firebase support.

From this experiment folder (where pubspec.yaml is located):
```bash
flutter create . --platforms=web
flutter pub get
flutter run -d chrome
```
`flutter create .` generates the platform runner files intentionally left out of this source-only package. Do not pass `--overwrite`. Keep this supplied lib/main.dart.

Before the final flutter run, complete Firebase setup:
1. Install Node.js and the Firebase CLI: `npm install -g firebase-tools`.
2. Run `firebase login`.
3. Run `dart pub global activate flutterfire_cli`.
4. Add the Dart global executable directory to PATH: Linux uses `$HOME/.pub-cache/bin`; Windows normally uses `%LOCALAPPDATA%\Pub\Cache\bin`. Restart the terminal, then run `flutterfire configure --platforms=web` from this folder and select your Firebase project.
5. This creates `lib/firebase_options.dart`, which the program imports. It is project-specific and is intentionally not bundled.
6. Create a Cloud Firestore database in the Firebase console.
7. Use an isolated lab project with console test-mode rules only for the lab demonstration. These expire; do not publish an app using open rules or enter real personal data. Before sharing/deploying, restrict rules to authorized users. These samples do not deploy or change rules for you.
8. Run `flutter run -d chrome`; network access and permitted Firestore rules are needed for cloud operations.

## Expected output and checks

Create Prepare lab assigned to Kevin. Move progress to 0, 50 and 100; check status and preserved fields. Edit title/assignee, filter, cancel and delete.

## Result to write after successful execution
Thus, Experiment 9, Firestore Task Updates, was implemented and its output was observed.

## Sample scope

Includes title/assignee edits, progress/status updates, status filtering and deletion. Due dates and priorities are omitted. Edit is a multi-field update, not replacement of the entire document.

## Verification status
Source reviewed and Dart syntax parsed successfully. Dependency YAML and matching abc.txt copies were checked. These are syntax and package-content checks, not Flutter analysis or execution: compilation, dependency resolution, widget tests and device/cloud behaviour remain unverified because the Flutter SDK is unavailable here.

## Reference
https://firebase.google.com/docs/flutter/setup
https://firebase.google.com/docs/firestore/query-data/queries

## Local verification
After the platform and any Firebase setup, run `flutter pub get`, `flutter analyze lib/main.dart`, and the run command for your target above. Check normal, empty and invalid inputs against Expected output and checks.
