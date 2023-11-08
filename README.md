## Possibly the easiest way to build C++ into Flutter

I only just got this working... I have yet to go through these steps again to make sure I didn't forget to type something into here.

## TODO
- [ ] FFI callbacks
- [ ] FFI awaits
- [ ] UI simulators
- [ ] Linux -> Linux
- [ ] Linux -> Android

### Making the UI
- Make it's own directory, `UI`
- Make a simple navigator using the [DefaultTabController](https://api.flutter.dev/flutter/material/DefaultTabController-class.html)

### Implementing C++ JSON Library
- Download [`json.hpp`](https://github.com/nlohmann/json/releases) and put in `json_library\src`
- Create a bridge C++ class (Don't know if that is best practice or not... new to this) and `.def` file
- Create `json_library\CMakeLists.txt` and a build/generator script
- Create root level `.gitignore` for `*library/bin` and `*library/build`

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
