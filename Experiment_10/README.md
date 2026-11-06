# Experiment 10: User Registration and Login

## Simple idea
Register and log in using Firebase Authentication, with Firestore profiles.

## Aim

To develop a Flutter application demonstrating user registration and login.

## Description (12 points)

1. The application provides registration, login, profile display and logout. This version uses Firebase Authentication for credentials and Firestore for profile information.

2. Firebase is initialized before the application starts. Email/Password sign-in must be enabled in the selected Firebase project.

3. The registration form collects a name, email, password, confirmation and role. Password fields hide the entered characters on screen.

4. Local checks require a name, an email containing an at sign and matching passwords with at least six characters. Firebase performs its own email and password-policy validation as well.

5. createUserWithEmailAndPassword creates the account and signs the user in. The returned UID identifies that user without depending on a changeable display name.

6. A Firestore document under users uses the UID as its ID. It stores the name, email, role and a server timestamp for the last login; the password is not stored in this profile.

7. signInWithEmailAndPassword checks an existing account. A successful login also attempts to update the last-login timestamp in Firestore.

8. authStateChanges provides the current sign-in state. The application displays the form when signed out and the profile controls when signed in.

9. The profile area displays the email, stored name, role and last-login time. It shows loading or error information if the profile cannot be read.

10. Save profile allows the signed-in user to create a missing profile or correct the name and displayed role. Roles in this lab are labels and do not enforce authorization.

11. Logout ends the Firebase session and returns to the sign-in form. The app reports partial failures clearly because account creation and profile storage are separate operations.

12. Enable Email/Password and permitted profile access, register a demo account and log out. Test mismatched passwords, duplicate registration, wrong-password login and correct login, then check both Auth and Firestore records.

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
9. Enable Authentication > Sign-in method > Email/Password. In production, restrict users/{uid} profile access to the matching authenticated UID. For testing use a new demo email, Kevin as the name, and a demo password. Firebase can enforce stronger password requirements than the local minimum.

## Expected output and checks

Register a new demo email with Kevin, matching password confirmation and Student role. Check the profile, last login, logout, wrong password, duplicate email and correct login.

## Result to write after successful execution
Thus, Experiment 10, User Registration and Login, was implemented and its output was observed.

## Sample scope

Uses Firebase Authentication instead of the original manual SHA-256 comparison. Self-selected roles are display labels only. No production access-control system is implemented.

## Verification status
Source reviewed and Dart syntax parsed successfully. Dependency YAML and matching abc.txt copies were checked. These are syntax and package-content checks, not Flutter analysis or execution: compilation, dependency resolution, widget tests and device/cloud behaviour remain unverified because the Flutter SDK is unavailable here.

## Reference
https://firebase.google.com/docs/flutter/setup
https://firebase.google.com/docs/firestore/query-data/queries

## Local verification
After the platform and any Firebase setup, run `flutter pub get`, `flutter analyze lib/main.dart`, and the run command for your target above. Check normal, empty and invalid inputs against Expected output and checks.
