project( flutter_sys_template LANGUAGES CXX C )

cmake_minimum_required( VERSION 3.4.1 )

set( SOURCE_PATH "../../../json_library/src" )
file( GLOB_RECURSE CPPS "${SOURCE_PATH}/*.cpp" )
file( GLOB_RECURSE HPPS "${SOURCE_PATH}/*.hpp" )
file( GLOB_RECURSE DEFS "${SOURCE_PATH}/*.def" )
file( GLOB_RECURSE HS "${SOURCE_PATH}/*.h" )
file( GLOB_RECURSE CS "${SOURCE_PATH}/*.c" )

add_library(
        json
        SHARED
        ${CPPS} ${CS} ${HPPS} ${HS} ${DEFS} )