# flutter_sys_template

UI for interacting with larger systems architectures.

## Features

- C++ JSON FFI
- just staring out...

## How to reproduce

### Making the UI
- Made it's own directory
- Make a simple navigator using the [DefaultTabController](https://api.flutter.dev/flutter/material/DefaultTabController-class.html)

### Implementing C++ JSON Library
- Download [`json.hpp`](https://github.com/nlohmann/json/releases) and put in `json_library\include`
- Create a bridge C++ class (Don't know if that is best practice or not... new to this)
- Create `json_library\CMakeLists.txt` which will bundle all the files together and make a `*test.exe` and `*library.dll` in a new `json_library\bin\Debug` directory

### ![windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
1. Download and install [CMake](https://cmake.org/download/) and make sure to add to path during installation
1. Download and install [VS2022 Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe)
1. Open PowerShell and run `where.exe /R C:\ msbuild` and confirm that `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe` is present
1. Add `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe` to Environment Variables PATH
1. `winget install -e --id LLVM.LLVM` (For dart ffigen)
1. Restart any open shells
1. run `json_library\scripts\win_build.bat`

### ![android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
1. TODO cmake and such has to be installed
1. run `json_library\scripts\build.sh`
1. Why won't android play nice?! Seriously, this NDK stuff is ridiculous!
    - I know I am not cross-compiling for proper android platforms
    - *.so is present on device but is missing other *.so files
    - Really, really annoying - will go back through the terrible dart plugin method I suppose