#!/bin/bash

# Change directory to the specified path
cd ../

# Create a build directory
mkdir build

# Change directory to the build directory
cd build

# Run CMake
cmake ../
make

# Run the test .exe and redirect output to a file
cd ../bin
./json_library_test > test_output.txt

# Search for the string "true" in the output file
grep -i "true" test_output.txt

# If the string "true" is found, the test is successful
if [[ $? -eq 0 ]]; then
  echo "TEST EXE SUCCESSFUL"
  rm test_output.txt
else
  echo "TEST EXE FAIL"
fi

# Change directory back to the original working directory
cd ../build

mkdir ../../UI/android/app/src/main/jniLibs
mkdir ../../UI/android/app/src/main/jniLibs/arm64-v8a
mkdir ../../UI/android/app/src/main/jniLibs/armeabi-v7a
mkdir ../../UI/android/app/src/main/jniLibs/x86
mkdir ../../UI/android/app/src/main/jniLibs/x86_64
cp libjson_library.so ../../UI/android/app/src/main/jniLibs/arm64-v8a/libjson.so
cp libjson_library.so ../../UI/android/app/src/main/jniLibs/armeabi-v7a/libjson.so
cp libjson_library.so ../../UI/android/app/src/main/jniLibs/x86/libjson.so
cp libjson_library.so ../../UI/android/app/src/main/jniLibs/x86_64/libjson.so