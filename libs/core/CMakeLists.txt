add_library(core
    src/hello.cpp
)

target_include_directories(core
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

set_project_warnings(core)