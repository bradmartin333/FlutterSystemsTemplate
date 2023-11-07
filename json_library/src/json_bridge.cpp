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

json get_test_json() 
{
    return {
        {"pi", 3.141},
        {"happy", true},
        {"name", "Niels"},
        {"nothing", nullptr},
        {
            "answer", {
                {"everything", 42}
            }
        },
        {"list", {1, 0, 2}},
        {
            "object", {
                {"currency", "USD"},
                {"value", 42.99}
            }
        }
    };
}

int main()
{
    // create a JSON object
    json j = {};
    
    // add new values
    j["valid"] = {true};

    // pretty print with indent of 4 spaces
    std::cout << std::setw(4) << j << '\n';
}

EXTERNC char *hello_json()
{
    json j = get_test_json();
    std::string s = j.dump(); 
    std::cout << s;

    const size_t length = s.length(); 
    std::cout << length;

    char* char_array = new char[length + 1]; 
    strcpy_s(char_array, length + 1, s.c_str());
    std::cout << char_array;

    return char_array;
}