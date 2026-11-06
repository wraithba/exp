# Experiment 7: Firestore Employee Records

## Simple idea
Add, stream and delete real cloud employee records.

## Aim

To develop a Flutter application demonstrating firestore employee records.

## Description (12 points)

1. The application creates a shared employee directory using Cloud Firestore. The records are stored in a real cloud collection rather than a temporary sample list.

2. Firebase is initialized using the generated project configuration before the interface opens. An initialization error is displayed when the configured project cannot be started.

3. The employees collection stores one document for each employee. The entered employee ID becomes the document ID.

4. The form accepts an employee ID, name and department. The department dropdown provides Engineering, HR and Sales sample options.

5. The program rejects empty IDs, empty names and IDs containing a slash. This avoids invalid document paths and incomplete employee details.

6. A transaction reads the chosen employee document before writing. If it already exists, the application reports a duplicate instead of overwriting the employee.

7. A successful transaction stores the employee name and department. The operation message tells the user whether the action completed or failed.

8. StreamBuilder listens to employee snapshots and refreshes the directory as documents change. A loading indicator is shown while the first response is pending.

9. The search field matches names or employee IDs without considering letter case. This search is applied to the employee documents currently loaded from Firestore.

10. A department filter further limits the displayed records. An empty-result message explains when no employee matches the combined controls.

11. The delete icon removes the selected employee document from Firestore. Buttons are disabled during an operation to reduce repeated submissions, and database errors remain visible.

12. Configure Firebase, add EMP7081 with Kevin as the name, and check the cloud document. Test the duplicate ID, department filtering, an unknown search and deletion in the Firestore console.

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

Add EMP7081, Kevin, Engineering. Verify the cloud document, duplicate rejection, name/ID search, department filter and deletion.

## Result to write after successful execution
Thus, Experiment 7, Firestore Employee Records, was implemented and its output was observed.

## Sample scope

Includes ID/name/department, add/delete, search and filtering. No employee editing or pagination.

## Verification status
Source reviewed and Dart syntax parsed successfully. Dependency YAML and full application sources were checked; abc.txt is now a separate short sample. These are syntax and package-content checks, not Flutter analysis or execution: compilation, dependency resolution, widget tests and device/cloud behaviour remain unverified because the Flutter SDK is unavailable here.

## Reference
https://firebase.google.com/docs/flutter/setup
https://firebase.google.com/docs/firestore/query-data/queries

## Local verification
After the platform and any Firebase setup, run `flutter pub get`, `flutter analyze lib/main.dart`, and the run command for your target above. Check normal, empty and invalid inputs against Expected output and checks.

## Short code for writing on paper

Read `abc.txt` for the minimal study example. Firestore employee add, duplicate-ID check, live list and delete. Only ID and name are used. The description above explains the fuller application in `lib/main.dart`; do not describe omitted features as part of the short sample. The short samples have been reviewed but have not been compiled or run.
