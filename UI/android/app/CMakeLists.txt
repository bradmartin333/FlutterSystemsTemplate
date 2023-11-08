project(flutter_sys_template LANGUAGES CXX)

cmake_minimum_required(VERSION 3.4.1)

set( SOURCE_PATH "../../../json_library/src" )
file( GLOB_RECURSE CPPS "${SOURCE_PATH}/*.cpp" )
file( GLOB_RECURSE HPPS "${SOURCE_PATH}/*.hpp" )
file( GLOB_RECURSE DEFS "${SOURCE_PATH}/*.def" )

add_library(
        json
        SHARED
        ${CPPS}
        ${HPPS}
        ${DEFS} )