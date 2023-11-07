cmake_minimum_required( VERSION 3.7 FATAL_ERROR )
project( json_library LANGUAGES CXX )

set( TARGET ${PROJECT_NAME} )
set( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin )

set( SOURCE_PATH "${PROJECT_SOURCE_DIR}/src" )
set( INCLUDE_PATH "${PROJECT_SOURCE_DIR}/include" )

file( GLOB_RECURSE HPPS "${INCLUDE_PATH}/*.hpp" )
file( GLOB_RECURSE DEFS "${INCLUDE_PATH}/*.def" )
file( GLOB_RECURSE CPPS "${SOURCE_PATH}/*.cpp" )

add_library( ${TARGET} SHARED ${CPPS} ${HPPS} ${DEFS} )
add_executable( "${TARGET}_test" ${CPPS} ${HPPS} ${DEFS} )

target_include_directories( ${TARGET} PUBLIC ${INCLUDE_PATH} )
target_include_directories( "${TARGET}_test" PUBLIC ${INCLUDE_PATH} )

install( 
    TARGETS ${TARGET} "${TARGET}_test"
    RUNTIME DESTINATION 
)

set_target_properties( ${TARGET} PROPERTIES
    PUBLIC_HEADER "${PROJECT_SOURCE_DIR}/include/json_bridge.hpp"
    SOVERSION 1
    OUTPUT_NAME ${TARGET}
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Hex_Identity_ID_Goes_Here"
)