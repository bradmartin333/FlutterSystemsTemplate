#include <iostream>
#include <iomanip>
#include <json.hpp>
#include <stdio.h>

using json = nlohmann::json;
using std::to_string;

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
    json j = get_test_json();
    
    // add new values
    j["new"]["key"]["value"] = {"another", "list"};

    // count elements
    auto s = j.size();
    j["size"] = s;

    // pretty print with indent of 4 spaces
    std::cout << std::setw(4) << j << '\n';
}

const char *hello_json()
{
    auto j_str = get_test_json().dump();
    const char *c = j_str.c_str();
    return c;
}