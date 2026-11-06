# Experiment 1: Fruit Market App

## Simple idea
Display fruit names and prices as reusable cards.

## Aim

To develop a Flutter application demonstrating fruit market app.

## Description (12 points)

1. This application presents a small fruit catalog with names, prices and useful information. It demonstrates how repeated information can be displayed clearly in Flutter.

2. Each fruit is stored as a map containing its name, price, description and nutrient. All fruit maps are grouped in a list so the screen can read them in order.

3. The main function starts the application using runApp. MaterialApp provides the basic application structure and opens the fruit screen.

4. Scaffold divides the screen into a title bar and a content area. AppBar displays the Fruit Market title at the top.

5. A summary above the list shows the number of fruits available. This count is calculated from the list length rather than typed separately.

6. ListView displays the fruit entries in a vertical list. Users can scroll when the cards extend beyond the available screen height.

7. The map method converts each fruit record into a FruitCard widget. This avoids repeating the same layout separately for every fruit.

8. FruitCard is a reusable widget that accepts one fruit record. Its layout can be changed once to update every fruit card.

9. Each card uses ListTile to show the fruit name and price. The subtitle displays a short description and a nutrient label.

10. The prices are shown in rupees per kilogram, as stated in the catalog summary. The descriptions and nutrient labels are sample information for the demonstration.

11. This screen uses StatelessWidget because users do not edit the fruit data. Changing the sample dataset changes the number and content of the displayed cards.

12. Run the application and compare every card with its stored record. Check the count, readable text and scrolling; similar layouts are useful for grocery catalogs and menus.

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

Five fruit cards with prices, descriptions and nutrients, plus the correct item count.

## Result to write after successful execution
Thus, Experiment 1, Fruit Market App, was implemented and its output was observed.

## Sample scope

Small teaching dataset; no purchases or cart.

## Verification status
Source reviewed and Dart syntax parsed successfully. Dependency YAML and matching abc.txt copies were checked. These are syntax and package-content checks, not Flutter analysis or execution: compilation, dependency resolution, widget tests and device/cloud behaviour remain unverified because the Flutter SDK is unavailable here.

## Local verification
After the platform and any Firebase setup, run `flutter pub get`, `flutter analyze lib/main.dart`, and the run command for your target above. Check normal, empty and invalid inputs against Expected output and checks.
