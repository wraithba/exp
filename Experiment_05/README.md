# Experiment 5: Named Routes and Feedback

## Simple idea
Send a course to another screen and return a feedback comment.

## Aim

To develop a Flutter application demonstrating named routes and feedback.

## Description (12 points)

1. The application contains a course catalog, a details screen and a feedback form. These screens demonstrate a complete navigation flow rather than showing only a button.

2. The home screen displays Flutter and Python courses as cards. Each card includes a short instruction and an arrow showing that it can be opened.

3. Named routes are registered in MaterialApp for the home, details and feedback screens. The route names identify which screen should open.

4. Selecting a course calls Navigator.pushNamed and sends the course name through arguments. The details screen therefore knows which course the user selected.

5. The details screen reads the argument using ModalRoute. A default course title prevents a crash when a name is not supplied.

6. Each course displays a description, beginner level, sample duration and a short topic list. The Flutter and Python courses show different content.

7. The Give Feedback button opens the feedback form and awaits a returned result. The details screen stays underneath it in the navigation stack.

8. The form collects a name, rating and comment. A dropdown provides ratings from one to five, while text fields accept the written details.

9. Leading and trailing spaces are removed from the name and comment. Empty values display a message and keep the form open for correction.

10. Navigator.pop closes a valid feedback form and returns a map containing all three values. The details screen checks the returned value before using it.

11. setState displays the submitted feedback in a card on the details screen. Opening the form and cancelling does not replace the previous feedback.

12. Run both course flows and test valid feedback, empty fields and cancellation. Content can scroll on small windows; feedback lasts while the details screen stays open and is not stored permanently.

## Run on Windows or Linux
Install the current stable Flutter SDK and put Flutter on PATH. Run `flutter doctor` and resolve issues for the target you choose. Run commands inside this experiment folder containing pubspec.yaml.

### Windows desktop (on a Windows computer)
Install Visual Studio (not only VS Code) with the Desktop development with C++ workload, including the Windows SDK. Then:
```powershell
flutter config --enable-windows-desktop
flutter create . --platforms=windows
flutter pub get
flutter run -d windows
```
If Windows reports a plugin symlink error, enable Windows Developer Mode and retry.

### Linux desktop (on a Linux computer)
On Ubuntu/Debian install the build dependencies:
```bash
sudo apt-get update
sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev libstdc++-12-dev libsqlite3-0 libsqlite3-dev
flutter config --enable-linux-desktop
flutter create . --platforms=linux
flutter pub get
flutter run -d linux
```
Other distributions need equivalent development packages. Do not use --overwrite with flutter create. Native Windows builds require Windows; native Linux builds require Linux.

### Optional Chrome route on either operating system
With Chrome installed:
```text
flutter create . --platforms=web
flutter pub get
flutter run -d chrome
```

## Expected output and checks

Select both courses; submit Kevin, 4 stars and Useful course. The returned card displays all three values. Empty inputs fail and cancellation preserves the earlier result.

## Result to write after successful execution
Thus, Experiment 5, Named Routes and Feedback, was implemented and its output was observed.

## Sample scope

Includes course information and returned name/rating/comment. About screen and custom unknown-route screen are omitted.

## Verification status
Source reviewed and Dart syntax parsed successfully. Dependency YAML and matching abc.txt copies were checked. These are syntax and package-content checks, not Flutter analysis or execution: compilation, dependency resolution, widget tests and device/cloud behaviour remain unverified because the Flutter SDK is unavailable here.

## Verification commands
After Flutter is installed, run from Experiment_05:
```text
flutter pub get
flutter analyze lib/main.dart test/exp05_test.dart
flutter test test/exp05_test.dart
```
Five widget tests cover both courses, returned feedback, whitespace input, cancellation and missing route arguments. They are supplied but have NOT been executed here. The feedback form scrolls when the available height is small. Confirm visually after launch as well.
