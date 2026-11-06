# Experiment 4: Mileage and Fuel Cost Calculator

## Simple idea
Calculate mileage and fuel cost from four validated numeric inputs.

## Aim

To develop a Flutter application demonstrating mileage and fuel cost calculator.

## Description (12 points)

1. The application calculates vehicle mileage and fuel cost from user input. It also keeps the successful results in a temporary session history.

2. Four input fields collect the initial odometer reading, final reading, fuel consumed and price per litre. This version uses kilometres, litres and rupees.

3. TextEditingController objects hold the values entered in the fields. A small list of labels creates the four input fields without repeating the complete field code.

4. Pressing Calculate reads the input text and attempts conversion using double.tryParse. Missing values, invalid numbers and non-finite values are rejected.

5. The initial odometer reading cannot be negative. The final reading must be greater than the initial reading so that the distance travelled is positive.

6. Fuel consumed must be greater than zero. This prevents division by zero and avoids a meaningless mileage result.

7. The fuel price cannot be negative. All four fields are required in this version, although a price of zero is allowed.

8. Distance is calculated by subtracting the initial reading from the final reading. Mileage is calculated by dividing that distance by the fuel consumed.

9. Fuel cost is calculated by multiplying fuel consumed by the price per litre. The result displays mileage and cost rounded to two decimal places.

10. Each successful calculation is added to the top of the session history. Invalid inputs display a message without adding a history entry.

11. Clear inputs empties the fields and current result, while Clear history removes the saved session calculations. The history is not a permanent database and disappears after restarting the app.

12. Run with 1000, 1200, 10 and 100 to obtain 20 km/l and Rs. 1000. Then test zero fuel, reversed readings and missing values, and check the two clearing actions.

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

Inputs 1000, 1200, 10, 100 produce 20.00 km/l and Rs. 1000.00, with a new history entry. Zero fuel fails validation.

## Result to write after successful execution
Thus, Experiment 4, Mileage and Fuel Cost Calculator, was implemented and its output was observed.

## Sample scope

Metric units only; all four fields are required. History is session-only.

## Verification status
Source reviewed and Dart syntax parsed successfully. Dependency YAML and full application sources were checked; abc.txt is now a separate short sample. These are syntax and package-content checks, not Flutter analysis or execution: compilation, dependency resolution, widget tests and device/cloud behaviour remain unverified because the Flutter SDK is unavailable here.

## Local verification
After the platform and any Firebase setup, run `flutter pub get`, `flutter analyze lib/main.dart`, and the run command for your target above. Check normal, empty and invalid inputs against Expected output and checks.

## Short code for writing on paper

Read `abc.txt` for the minimal study example. Mileage, cost and input checks. History and unit switching are omitted. The description above explains the fuller application in `lib/main.dart`; do not describe omitted features as part of the short sample. The short samples have been reviewed but have not been compiled or run.


## HTML version

Open `index.html` for the browser version of `lib/main.dart`. It recreates the controls, data and interactions with HTML, CSS and JavaScript; appearance may differ slightly from Flutter.

From the repository root, run `python -m http.server 8000` (Windows: `py -m http.server 8000`), then visit `http://localhost:8000/Experiment_04/`.
