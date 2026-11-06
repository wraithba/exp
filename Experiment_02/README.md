# Experiment 2: Responsive Product Catalog

## Simple idea
Change a product grid from two to four columns as width increases.

## Aim

To develop a Flutter application demonstrating responsive product catalog.

## Description (12 points)

1. The application displays products in a responsive catalog. Users can select a category and choose how the product list is arranged.

2. Each product record contains a name, price and category. The sample includes electronic products and clothing items.

3. A StatefulWidget keeps track of the selected category and the grid-view switch. These values determine which products and layout appear.

4. The category dropdown provides All, Electronics and Clothing options. Selecting All makes every sample product available for display.

5. The where method filters the product list by the selected category. The displayed product count is based on the filtered list.

6. The grid-view switch changes between a grid and a vertical list. This changes the presentation without changing the selected category.

7. LayoutBuilder supplies the width available to the product area. The program uses this width to select a suitable grid column count.

8. GridView.count arranges product cards in columns. It provides a shorter way to create a fixed-column grid than writing a separate grid delegate.

9. On a very narrow screen the grid uses one column, then two on smaller screens and four on larger screens. This gives product information more room as the available width changes.

10. Each card shows a shopping icon, product name, price and category. The same product information is used in both display modes.

11. setState rebuilds the screen after a category or display-mode change. The controls can scroll if the window is too short to show them together.

12. Run the app, select each category, switch layouts and resize the window. This demonstrates the responsive browsing behaviour used in shopping and inventory applications.

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

Select Electronics or Clothing, switch grid/list views, and resize from one to two to four columns.

## Result to write after successful execution
Thus, Experiment 2, Responsive Product Catalog, was implemented and its output was observed.

## Sample scope

Includes category and grid/list controls; discounts, ratings and a separate desktop sidebar are omitted.

## Verification status
Source reviewed and Dart syntax parsed successfully. Dependency YAML and full application sources were checked; abc.txt is now a separate short sample. These are syntax and package-content checks, not Flutter analysis or execution: compilation, dependency resolution, widget tests and device/cloud behaviour remain unverified because the Flutter SDK is unavailable here.

## Local verification
After the platform and any Firebase setup, run `flutter pub get`, `flutter analyze lib/main.dart`, and the run command for your target above. Check normal, empty and invalid inputs against Expected output and checks.

## Short code for writing on paper

Read `abc.txt` for the minimal study example. Responsive grid using GridView.count. Category filters, prices and grid/list switching are omitted. The description above explains the fuller application in `lib/main.dart`; do not describe omitted features as part of the short sample. The short samples have been reviewed but have not been compiled or run.


## HTML version

Open `index.html` for the browser version of `lib/main.dart`. It recreates the controls, data and interactions with HTML, CSS and JavaScript; appearance may differ slightly from Flutter.

From the repository root, run `python -m http.server 8000` (Windows: `py -m http.server 8000`), then visit `http://localhost:8000/Experiment_02/`.
