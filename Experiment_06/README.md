# Experiment 6: SQLite Student Records

## Simple idea
Save and retrieve student records locally, including duplicate checking.

## Aim

To develop a Flutter application demonstrating sqlite student records.

## Description (12 points)

1. The application stores student information in a local SQLite database. It demonstrates saving records that remain available after the application is reopened on the same computer.

2. The desktop version uses sqflite_common_ffi to access SQLite on Windows and Linux. The database factory is initialized before the application starts.

3. The database is opened when the student screen is created. A students table is created automatically if the new database file does not yet exist.

4. Each table row contains a roll number, student name, course and CGPA. The roll number is the primary key, so two rows cannot use the same roll number.

5. Four input fields collect the student details. The program checks that all text fields are completed and the CGPA is a valid finite number from zero to ten.

6. The database must finish opening before a record can be saved. A message explains if the user tries to save before it is ready.

7. A parameterized query checks whether the roll number already exists. A duplicate is rejected, while the primary-key constraint also protects the table.

8. The insert method writes valid student details into the table. The records are then queried again so the visible list reflects the saved data.

9. A search field filters the loaded records by student name or roll number. Searching does not delete or modify the stored records.

10. The summary displays the total number of students and average CGPA. Each result card shows the name, roll number, course and individual CGPA.

11. Database operations display errors if they fail. The expanded sample uses a new local database filename so it does not conflict with the earlier two-field table.

12. Run on Windows or Linux desktop, add Kevin, try a repeated roll and test CGPA boundaries. Restart the app on the same computer to check persistence; the file does not synchronize between computers.

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

Experiment 6 uses desktop SQLite through sqflite_common_ffi and bundled SQLite libraries. Do not run this sample in Chrome. Your data persists on the same computer; it does not synchronize between Windows and Linux.

## Expected output and checks

Add DEMO7081, Kevin, CSE, 8.5. Check the list, total and average, search by roll/name, reject a duplicate or CGPA 11 and reopen to check persistence.

## Result to write after successful execution
Thus, Experiment 6, SQLite Student Records, was implemented and its output was observed.

## Sample scope

Desktop SQLite with roll, name, course and CGPA. Email, deletion and editing are omitted. Uses a new lab_students_v2.db file; earlier saved rows are not migrated.

## Verification status
Source reviewed and Dart syntax parsed successfully. Dependency YAML and full application sources were checked; abc.txt is now a separate short sample. These are syntax and package-content checks, not Flutter analysis or execution: compilation, dependency resolution, widget tests and device/cloud behaviour remain unverified because the Flutter SDK is unavailable here.

## Reference
https://docs.flutter.dev/cookbook/persistence/sqlite

## Local verification
After the platform and any Firebase setup, run `flutter pub get`, `flutter analyze lib/main.dart`, and the run command for your target above. Check normal, empty and invalid inputs against Expected output and checks.

## Short code for writing on paper

Read `abc.txt` for the minimal study example. SQLite desktop save/retrieve with unique roll numbers. Only roll and name are stored; course, CGPA and search are omitted. The description above explains the fuller application in `lib/main.dart`; do not describe omitted features as part of the short sample. The short samples have been reviewed but have not been compiled or run.
