cmake_minimum_required(VERSION 3.22)

project(wos)

set(CMAKE_TOOLCHAIN_FILE "../toolchain.cmake")
MESSAGE("-- CMAKE_C_COMPILER=" ${CMAKE_C_COMPILER})

set(CMAKE_ASM_SOURCE_FILE_EXTENSIONS "s" "h")
set(CMAKE_C_SOURCE_FILE_EXTENSIONS "c" " h")
set(CMAKE_CXX_SOURCE_FILE_EXTENSIONS "cpp" "h")

set(CMAKE_SOURCE_DIR src)

set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/linker.ld)
list(APPEND SRC_ASM_FILES ${CMAKE_SOURCE_DIR}/booter.s)
list(APPEND SRC_C_FILES ${CMAKE_SOURCE_DIR}/main.c)
list(APPEND SRC_CXX_FILES ${CMAKE_SOURCE_DIR}/main.cpp)
list(APPEND SRC_HEADER_FILES
        ${CMAKE_SOURCE_DIR}/main.h
        ${CMAKE_SOURCE_DIR}/main.hpp
)

add_executable(
        ${CMAKE_PROJECT_NAME}
        ${SRC_ASM_FILES}
        ${SRC_C_FILES}
        ${SRC_CXX_FILES}
)

set_target_properties(${PROJECT_NAME} PROPERTIES LINK_DEPENDS ../${LINKER_SCRIPT})
