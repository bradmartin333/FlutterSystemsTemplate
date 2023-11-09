#define _CRT_SECURE_NO_WARNINGS

#include <iostream>
#include <thread>
#include <ctype.h>
#include <memory.h>
#include <math.h>
#include "json.hpp"
#include "dart/dart_api_dl.h"
#include "mp/map.h"

using json = nlohmann::json;
using std::to_string;

#ifdef __cplusplus
#define EXTERNC extern "C"
#else
#define EXTERNC
#endif

std::string MAPSTR =
    "     x      x                x"
    "     x      xxxxxx    x      x"
    "xxxx xxxxxxxx      xxxxxxx    "
    "   x                     xxx x"
    "        xxxxxx  xxxxx         "
    "xxxx x  x    x            x   "
    "   x x  xxxxxx    xxxxxx  xxxx"
    "   x x            x    x      "
    "   x xxxxxxxxx  xxx    xxxx   "
    "xxxx                   x     x";

int main()
{
    json j = {};
    j["valid"] = true;

    std::cout << std::setw(4) << j << '\n';

    Map map = Map(0, 0, 30, 10, MAPSTR);
    map.SetPos(20, 8);
    map.Print();
}

EXTERNC char *hello_json()
{
    json j = {};
    j["valid"] = true;
    std::string s = j.dump();
    const size_t length = s.length();
    char *char_array = new char[length + 1];
    strcpy(char_array, s.c_str());
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
