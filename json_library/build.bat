@ECHO OFF

REM Go into a new build directory
IF EXIST build RD /S /Q build
mkdir build
cd build

REM Run the series of build commands
cmake ../
msbuild .\json_library.vcxproj
msbuild .\json_library_test.vcxproj

REM Run the test .exe and verify output
cd /D "../bin/Debug"
.\json_library_test.exe > test_output.txt

REM Verify the contents of the output file
TYPE test_output.txt | FINDSTR /I /R "true"
IF %ERRORLEVEL% EQU 0 (
    echo TEST EXE SUCCESSFUL
    del test_output.txt
) ELSE (
    echo TEST EXE FAIL
)

REM Regenerate the dart bindings
cd /D "../../../UI"
dart run ffigen --config config.yaml

REM Change directory back to the original working directory
cd /D "%~dp0"

PAUSE