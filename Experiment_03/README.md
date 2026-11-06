# Experiment 3: Product Search and Filter

## Simple idea
Find products by name and maximum price.

## Aim

To develop a Flutter application demonstrating product search and filter.

## Description (12 points)

1. The application helps users find products using several controls together. It demonstrates searching, filtering, sorting and resetting a product list.

2. Each product stores a name, price, category and stock status. These fields supply both the information on the cards and the values used for filtering.

3. A text field accepts the product name to search. The program removes surrounding spaces and compares lowercase text so uppercase and lowercase queries behave consistently.

4. The category dropdown limits results to Electronics or Clothing. The All option allows products from either category.

5. A slider selects the maximum permitted price. Only products whose price is less than or equal to that limit remain in the results.

6. The In stock only switch removes unavailable products when enabled. When it is disabled, stock status does not restrict the list.

7. The where method combines all active conditions with logical AND. A product must satisfy the search, category, price and stock conditions before it can appear.

8. The sort dropdown arranges the matching products by name or ascending price. Sorting changes the order of results rather than the filter conditions.

9. setState updates the screen when a control changes. The result count and product cards are rebuilt from the current selections.

10. A message displays No products found when the filtered list is empty. This makes an unsuccessful search clear instead of leaving an unexplained blank area.

11. The Reset button clears the visible search text and restores the default category, price limit, stock switch and sort order. The search controller is released when the screen closes.

12. Run the app and test Watch, WATCH, an unknown query and combined filters. Also test a zero price limit, price sorting and Reset; these actions reflect common product-search behaviour.

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

Search Watch and WATCH, combine category/price/stock filters, sort by price and use Reset. Unknown text gives No products found.

## Result to write after successful execution
Thus, Experiment 3, Product Search and Filter, was implemented and its output was observed.

## Sample scope

Includes search, category, maximum price, stock, sorting and reset. A minimum-price slider and rating sort are omitted.

## Verification status
Source reviewed and Dart syntax parsed successfully. Dependency YAML and matching abc.txt copies were checked. These are syntax and package-content checks, not Flutter analysis or execution: compilation, dependency resolution, widget tests and device/cloud behaviour remain unverified because the Flutter SDK is unavailable here.

## Local verification
After the platform and any Firebase setup, run `flutter pub get`, `flutter analyze lib/main.dart`, and the run command for your target above. Check normal, empty and invalid inputs against Expected output and checks.
