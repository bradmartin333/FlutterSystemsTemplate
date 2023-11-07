#define _CRT_SECURE_NO_WARNINGS

#include <iostream>
#include <json.hpp>

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
    strcpy(char_array, s.c_str());
    std::cout << char_array;

    return char_array;
}