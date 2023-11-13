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
    const size_t length = s.length();
    char *char_array = new char[length + 1];
    strcpy(char_array, s.c_str());
    return char_array;
}

EXTERNC void mapPath(json mapJson, int64_t port)
{
    Map map = Map(mapJson);
    json pathJson = map.Path();
    std::string s = pathJson.dump();
    Dart_CObject out_object;
    out_object.type = Dart_CObject_kString;
    out_object.value.as_string = s.c_str();
    bool ok = Dart_PostCObject_DL(port, &out_object);
}

EXTERNC int32_t makeMap(char *str, int length, int64_t port)
{
    char *json_str = new char[length + 1];
    memcpy(json_str, str, length);
    json_str[length] = '\0';
    json json = json::parse(json_str);
    std::thread map(mapPath, json, port);
    map.detach();
    return 0;
}
