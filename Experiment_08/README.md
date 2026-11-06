# Experiment 8: Firestore Book Search

## Simple idea
Add book titles and run real prefix or keyword queries.

## Aim

To develop a Flutter application demonstrating firestore book search.

## Description (12 points)

1. The application adds books to a Firestore catalog and searches their titles. It demonstrates the difference between title-prefix and exact-keyword queries.

2. The book form collects a title, author and genre. Empty titles or authors are rejected so that the displayed records contain useful identifying information.

3. Each book document stores the original title, author and genre. It also stores a lowercase title and a list of lowercase words used for searching.

4. The original title is preserved for display. The lowercase title allows consistent comparisons when users type different letter cases.

5. The keyword list is created by splitting the lowercase title at whitespace. Keyword mode matches a complete stored word, not any arbitrary substring.

6. The search-mode dropdown selects Prefix or Keyword. The query is executed when the user presses Search / show all.

7. Prefix mode orders documents by titleLower and uses a start and end range. This finds titles beginning with the entered text for the sample titles used in the lab.

8. Keyword mode uses arrayContains on the stored keyword list. For example, flutter can match the word in Kevin Flutter Guide.

9. An empty search query retrieves the catalog without a title condition. The selected genre is then applied locally to the returned results to avoid requiring a compound query in this sample.

10. Book cards display the title, author and genre. The screen distinguishes the initial instruction from the No books found message after a search.

11. After a book is added, the catalog is searched again using the current controls. Cloud failures are shown as errors, and buttons are disabled while an operation is running.

12. Configure Firebase, add Kevin Flutter Guide and test prefix kevin and keyword flutter. Also test an unknown query, an empty query and a genre with no matches.

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

Add Kevin Flutter Guide, Kevin, Technology. Prefix kevin and keyword flutter match; unknown text shows No books found. Empty query shows all matching the genre filter.

## Result to write after successful execution
Thus, Experiment 8, Firestore Book Search, was implemented and its output was observed.

## Sample scope

Title/author/genre with cloud prefix/keyword queries. Genre filtering is performed on fetched results; ISBN, punctuation-aware tokenization and pagination are omitted.

## Verification status
Source reviewed and Dart syntax parsed successfully. Dependency YAML and full application sources were checked; abc.txt is now a separate short sample. These are syntax and package-content checks, not Flutter analysis or execution: compilation, dependency resolution, widget tests and device/cloud behaviour remain unverified because the Flutter SDK is unavailable here.

## Reference
https://firebase.google.com/docs/flutter/setup
https://firebase.google.com/docs/firestore/query-data/queries

## Local verification
After the platform and any Firebase setup, run `flutter pub get`, `flutter analyze lib/main.dart`, and the run command for your target above. Check normal, empty and invalid inputs against Expected output and checks.

## Short code for writing on paper

Read `abc.txt` for the minimal study example. Firestore title-prefix and keyword search. Only titles are stored; author and genre are omitted. The description above explains the fuller application in `lib/main.dart`; do not describe omitted features as part of the short sample. The short samples have been reviewed but have not been compiled or run.
