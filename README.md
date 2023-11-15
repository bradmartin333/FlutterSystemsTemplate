# The most detailed systems template

## Features and Examples

- Android, Windows and Linux (More possible) support
- FFI
    - Dart to C++
    - C++ to Dart
    - [JSON Compatible](https://github.com/nlohmann/json)
- [State Management](https://docs.flutter.dev/data-and-backend/state-mgmt/simple)
- [Tab Controller](https://api.flutter.dev/flutter/material/TabController-class.html)
- [A* Path Generation](https://github.com/leethomason/MicroPather)
- [Key-value data persistence](https://docs.flutter.dev/cookbook/persistence/key-value)

## TODO

- [ ] More sample UI stuff
- [ ] Automated Linux release
- [ ] Go through all steps on new machine to validate!!!

### Making the UI

- Make it's own directory, `UI`
- Make a simple navigator using the [DefaultTabController](https://api.flutter.dev/flutter/material/DefaultTabController-class.html)
- Create a simple BLoC structure

### Implementing C++ JSON Library (To test with)

- Download [`json.hpp`](https://github.com/nlohmann/json/releases) and put in `json_library\src`
- Create a bridge C++ class (Don't know if that is best practice or not... new to this) and `.def` file
- Create `json_library\CMakeLists.txt` and a build/generator script
- Create root level `.gitignore` for `*library/bin` and `*library/build`

### Implementing async FFI with native ports

- Download the contents of the `json_library\src\dart` directory from the [dart-lang repo](https://github.com/dart-lang/sdk/tree/master/runtime/include)
- Add `Dart_InitializeApiDL` to the `.def` file
- Make some test functions in `*bridge.cpp` and include them in `*bridge.hpp` and the `.def` file
- Add `C` as a a language to `json_library\CMakeLists.txt`
- Look for `*.c` and `*.h` files in `json_library\CMakeLists.txt`
- Implement the `ReceivePort` and required funtions in `UI\lib\native_json.dart` as per [this comment](https://github.com/flutter/flutter/issues/63255#issuecomment-671216406)
- Add `../json_library/src/dart/dart_api_dl.h` to entry points in `UI\config.yaml`
- Update `UI\android\app\CMakeLists.txt` in the same way


### ![windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)

1. Download and install [CMake](https://cmake.org/download/) and make sure to add to path during installation
1. Download and install [VS2022 Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe)
1. Open PowerShell and run `where.exe /R C:\ msbuild` and confirm that `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe` is present
1. Add `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe` to Environment Variables PATH
1. `winget install -e --id LLVM.LLVM` (For dart ffigen)
1. Restart any open shells
1. Configure Flutter project for ffigen
    - Add `ffigen` to `dev_dependencies` in `UI\pubspec.yaml`
    - Create `UI\config.yaml` based off the file in this repo
    - Create empty `UI\lib\generated_bindings.dart`
1. run `json_library\build.bat`
1. Create wrapper like `UI\lib\native_json.dart`

### ![android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white) built from ![windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)

These steps assume that you have completed the windows specific steps above and also have a working Android Studio installation / android mobile emulator.

1. Add `**/.cxx` to `UI\android\.gitignore`
1. Setup CMake for Android
    - `where.exe cmake` in PowerShell should yield `C:\Program Files\CMake\bin\cmake.exe`
    - Update `UI\android\local.properties` by adding `cmake.dir=C:\\Program Files\\CMake` (Make sure not to have trailing slashes or bin!)
1. Update `UI\android\build.gradle` by adding:
    ```
    android {
        ...
        externalNativeBuild {
            cmake {
                path = file("CMakeLists.txt")
            }
        }
    }
    ```
1. (Not sure if necessary) Update beginning of `UI\android\app\src\main\AndroidManifest.xml` with:
    ```
    <manifest xmlns:android="http://schemas.android.com/apk/res/android" xmlns:tools="http://schemas.android.com/tools">
        <application
            ...
            android:extractNativeLibs="true"
            tools:replace="android:extractNativeLibs">
        </application>
    ```
1. Create `UI\windows\CMakeLists.txt` based off the file in this repo

### ![ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

Install the [manual way](https://docs.flutter.dev/get-started/install/linux#method-2-manual-installation), not using `snap`. Huge speed decrease with `snap`.

1. `sudo apt install cmake clang lldb lld`
1. `cd json_library/`
1. `./build.sh` (Not `sudo` or paths will be wrong!)

### ![android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white) built from ![ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

Coming Soon!
