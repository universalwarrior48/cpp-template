include_guard(GLOBAL)

find_program(CLANG_FORMAT_EXE NAMES clang-format)

if(CLANG_FORMAT_EXE)

file(GLOB_RECURSE ALL_SOURCE_FILES
    ${PROJECT_SOURCE_DIR}/src/*.cpp
    ${PROJECT_SOURCE_DIR}/include/*.hpp
)

add_custom_target(format
    COMMAND ${CLANG_FORMAT_EXE}
    -i
    ${ALL_SOURCE_FILES}
)

endif()