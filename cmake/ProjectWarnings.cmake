include_guard(GLOBAL)

add_library(project_warnings INTERFACE)

target_compile_options(project_warnings INTERFACE
    $<$<CXX_COMPILER_ID:Clang>:
        -Wall
        -Wextra
        -Wpedantic
        -Wconversion
        -Wshadow
    >

    $<$<CXX_COMPILER_ID:GNU>:
        -Wall
        -Wextra
        -Wpedantic
        -Wconversion
        -Wshadow
    >

    $<$<CXX_COMPILER_ID:MSVC>:
        /W4
    >
)