# Clean out old build dirs
sudo rm -rf bin
sudo rm -rf build

# Go into a new build directory
mkdir build && cd build

# Run the series of build commands
cmake ../
make

# Copy the library to where the UI expects it to be
cp libjson_library.so ../bin/libjson.so

# Run the test executable and capture output
cd ../bin
./json_library_test > test_output.txt

# Verify the contents of the output file
if grep -q true test_output.txt
then
  echo "TEST EXE SUCCESSFUL"
  rm test_output.txt
else
  echo "TEXT EXE FAIL"
fi

# Change directory back to the original working directory
cd ../json_library
