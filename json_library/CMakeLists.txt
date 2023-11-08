cmake_minimum_required( VERSION 3.7 FATAL_ERROR )
project( json_library LANGUAGES CXX C )

set( TARGET ${PROJECT_NAME} )
set( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin )

set( SOURCE_PATH "${PROJECT_SOURCE_DIR}/src" )

file( GLOB_RECURSE HPPS "${SOURCE_PATH}/*.hpp" )
file( GLOB_RECURSE DEFS "${SOURCE_PATH}/*.def" )
file( GLOB_RECURSE CPPS "${SOURCE_PATH}/*.cpp" )
file( GLOB_RECURSE HS "${SOURCE_PATH}/dart/*.h" )
file( GLOB_RECURSE CS "${SOURCE_PATH}/dart/*.c" )

add_library( ${TARGET} SHARED ${CPPS} ${CS} ${HPPS} ${HS} ${DEFS}  )
add_executable( "${TARGET}_test" ${CPPS} ${CS} ${HPPS} ${HS} ${DEFS}  )

install( 
    TARGETS ${TARGET} "${TARGET}_test"
    RUNTIME DESTINATION 
)

set_target_properties( ${TARGET} PROPERTIES
    SOVERSION 1
    OUTPUT_NAME ${TARGET}
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Hex_Identity_ID_Goes_Here"
)