#define _CRT_SECURE_NO_WARNINGS

#include <iostream>
#include <thread>
#include "json.hpp"
#include "dart/dart_api_dl.h"

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

    char *char_array = new char[length + 1];
    strcpy(char_array, s.c_str());
    std::cout << char_array;

    return char_array;
}

EXTERNC void bar(int32_t i, int64_t port)
{
    int out = i;
    std::this_thread::sleep_for(std::chrono::seconds(1));
    Dart_CObject out_object;
    out_object.type = Dart_CObject_kInt32;
    out_object.value.as_int32 = out;
    bool ok = Dart_PostCObject_DL(port, &out_object);
}

EXTERNC int32_t foo(int32_t i, int64_t port)
{
    std::thread test(bar, i, port);
    test.detach();
    return 0;
}