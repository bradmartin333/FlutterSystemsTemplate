#include <iostream>
#include <iomanip>
#include <json.hpp>
#include <stdio.h>

using json = nlohmann::json;
using std::to_string;

#ifdef __cplusplus
#define EXTERNC extern "C"
#else
#define EXTERNC
#endif

int main()
{
    json j = {};
    j["valid"] = true;

    std::cout << std::setw(4) << j << '\n';
}

EXTERNC char *hello_json()
{
    json j = {};
    j["valid"] = true;

    std::string s = j.dump(); 
    std::cout << s;

    const size_t length = s.length(); 
    std::cout << length;

    char* char_array = new char[length + 1]; 
    strcpy_s(char_array, length + 1, s.c_str());
    std::cout << char_array;

    return char_array;
}