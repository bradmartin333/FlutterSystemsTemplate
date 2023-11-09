#ifndef MAP_H
#define MAP_H

#include "micropather.h"
#include "../json.hpp"

using namespace micropather;
using json = nlohmann::json;
using std::to_string;

#ifdef __cplusplus
#define EXTERNC extern "C"
#else
#define EXTERNC
#endif

EXTERNC class Map : public Graph
{
private:
    int m_posX{};
    int m_posY{};
    int m_mapX{};
    int m_mapY{};
    std::string m_mapStr{};
    MPVector<void *> path{};
    MicroPather *pather{};

public:
    Map(int posX = 0, int posY = 0, int mapX = 0, int mapY = 0, std::string mapStr = "")
    {
        m_posX = posX;
        m_posY = posY;
        m_mapX = mapX;
        m_mapY = mapY;
        m_mapStr = mapStr;
        pather = new MicroPather(this, 20);
    }

    bool Passable(int nx, int ny)
    {
        const char *gMap = m_mapStr.c_str();
        if (nx >= 0 && nx < m_mapX && ny >= 0 && ny < m_mapY)
        {
            int index = ny * m_mapX + nx;
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
            result = pather->Solve(XYToNode(m_posX, m_posY), XYToNode(nx, ny), &path, &totalCost);
            if (result == MicroPather::SOLVED)
            {
                std::cout << "SOLVED\n";
                m_posX = nx;
                m_posY = ny;
            } else {
                std::cout << "UNSOLVED\n";
            }
        } else {
            std::cout << "INVALID MAP\n";
        }
        return result;
    }

    void Print()
    {
        MPVector<void *> stateVec;
        for (int j = 0; j < m_mapY; ++j)
        {
            unsigned size = path.size();
            for (unsigned k = 0; k < size; ++k)
            {
                int x, y;
                NodeToXY(path[k], &x, &y);
                if (y == j)
                    std::cout << x << ' ' << y << '\n';
            }
        }
    }

    void NodeToXY(void *node, int *x, int *y)
    {
        intptr_t index = (intptr_t)node;
        *y = index / m_mapX;
        *x = index - *y * m_mapX;
    }

    void *XYToNode(int x, int y)
    {
        return (void *)(y * m_mapX + x);
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

    virtual void AdjacentCost(void *node, micropather::MPVector<StateCost> *neighbors)
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
                // Normal floor
                StateCost nodeCost = {XYToNode(nx, ny), cost[i]};
                neighbors->push_back(nodeCost);
            }
            else
            {
                // Normal floor
                StateCost nodeCost = {XYToNode(nx, ny), FLT_MAX};
                neighbors->push_back(nodeCost);
            }
        }
    }

    virtual void PrintStateInfo(void *node)
    {
        int x, y;
        NodeToXY(node, &x, &y);
        printf("(%d,%d)", x, y);
    }
};

#endif