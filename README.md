# flutter_sys_template

UI for interacting with larger systems architectures.

## Features

- C++ FFI
- just staring out...

### Making the UI
- Made it's own directory
- Make a simple navigator using the [DefaultTabController](https://api.flutter.dev/flutter/material/DefaultTabController-class.html)

### Implementing C++ JSON Library
- Download [`json.hpp`](https://github.com/nlohmann/json/releases) and put in `json_library\include`
- Create a bridge C++ class (Don't know if that is best practice or not... new to this)
- Create `json_library\CMakeLists.txt` which will bundle all the files together and make a `*test.exe` and `*library.dll` in a new `json_library\bin\Debug` directory
    - ![windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
        - `cd json_library`
        - `mkdir build`
        - `cd build`
        - `cmake ../`
        - `msbuild .\json_library.vcxproj` for the `*library.dll`
        - `msbuild .\json_library_test.vcxproj` for the `*test.exe`
            - Running `*test.exe` should print out a sample JSON