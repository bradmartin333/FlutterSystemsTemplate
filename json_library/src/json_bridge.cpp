#define _CRT_SECURE_NO_WARNINGS

#include <iostream>
#include <thread>
#include <ctype.h>
#include <memory.h>
#include <math.h>
#include "mp/micropather.h"
#include "json.hpp"
#include "dart/dart_api_dl.h"

using json = nlohmann::json;
using std::to_string;

#ifdef __cplusplus
#define EXTERNC extern "C"
#else
#define EXTERNC
#endif

const int MAPX = 30;
const int MAPY = 10;
const char gMap[MAPX * MAPY + 1] =
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

class Map : public micropather::Graph
{
private:
    Map(const Map &);
    void operator=(const Map &);
    int playerX, playerY;
    micropather::MPVector<void *> path;
    micropather::MicroPather *pather;

public:
    Map() : playerX(0), playerY(0), pather(0)
    {
        pather = new micropather::MicroPather(this, 20); // Use a very small memory block to stress the pather
    }

    virtual ~Map()
    {
        delete pather;
    }

    int X() { return playerX; }
    int Y() { return playerY; }

    bool Passable(int nx, int ny)
    {
        if (nx >= 0 && nx < MAPX && ny >= 0 && ny < MAPY)
        {
            int index = ny * MAPX + nx;
            char c = gMap[index];
            return c == ' ';
        }
        return false;
    }

    int SetPos(int nx, int ny)
    {
        int result = 0;
        if (Passable(nx, ny))
        {
            float totalCost;
            result = pather->Solve(XYToNode(playerX, playerY), XYToNode(nx, ny), &path, &totalCost);
            if (result == micropather::MicroPather::SOLVED)
            {
                std::cout << "SOLVED\n";
                playerX = nx;
                playerY = ny;
            }
        }
        return result;
    }

    void Print()
    {
        char buf[MAPX + 1];
        micropather::MPVector<void *> stateVec;
        for (int j = 0; j < MAPY; ++j)
        {
            // Copy in the line.
            memcpy(buf, &gMap[MAPX * j], MAPX + 1);
            buf[MAPX] = 0;

            // Demo code
            unsigned k;
            unsigned size = path.size();
            for (k = 0; k < size; ++k)
            {
                int x, y;
                NodeToXY(path[k], &x, &y);
                if ( y == j )
                    std::cout << x << ' ' << y << '\n';
            }
        }
    }

    void NodeToXY(void *node, int *x, int *y)
    {
        intptr_t index = (intptr_t)node;
        *y = index / MAPX;
        *x = index - *y * MAPX;
    }

    void *XYToNode(int x, int y)
    {
        return (void *)(y * MAPX + x);
    }

    virtual float LeastCostEstimate(void *nodeStart, void *nodeEnd)
    {
        int xStart, yStart, xEnd, yEnd;
        NodeToXY(nodeStart, &xStart, &yStart);
        NodeToXY(nodeEnd, &xEnd, &yEnd);

        /* Compute the minimum path cost using distance measurement. It is possible
           to compute the exact minimum path using the fact that you can move only
           on a straight line or on a diagonal, and this will yield a better result.
        */
        int dx = xStart - xEnd;
        int dy = yStart - yEnd;
        return (float)sqrt((double)(dx * dx) + (double)(dy * dy));
    }

    virtual void AdjacentCost(void *node, micropather::MPVector<micropather::StateCost> *neighbors)
    {
        int x, y;
        const int dx[8] = {1, 1, 0, -1, -1, -1, 0, 1};
        const int dy[8] = {0, 1, 1, 1, 0, -1, -1, -1};
        const float cost[8] = {1.0f, 1.41f, 1.0f, 1.41f, 1.0f, 1.41f, 1.0f, 1.41f};

        NodeToXY(node, &x, &y);

        for (int i = 0; i < 8; ++i)
        {
            int nx = x + dx[i];
            int ny = y + dy[i];

            if (Passable(nx, ny))
            {
                micropather::StateCost nodeCost = {XYToNode(nx, ny), cost[i]};
                neighbors->push_back(nodeCost);
            }
            else
            {
                micropather::StateCost nodeCost = {XYToNode(nx, ny), FLT_MAX};
                neighbors->push_back(nodeCost);
            }
        }
    }

    virtual void PrintStateInfo(void *node)
    {
        int x, y;
        NodeToXY(node, &x, &y);
        std::cout << '(' << x << ',' << y << ")\n";
    }
};

int main()
{
    json j = {};
    j["valid"] = true;

    std::cout << std::setw(4) << j << '\n';

    Map map;
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
