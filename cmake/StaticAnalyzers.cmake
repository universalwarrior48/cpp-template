option(ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)

if(ENABLE_CLANG_TIDY)

set(CMAKE_CXX_CLANG_TIDY
    clang-tidy;
    -checks=*;
    -warnings-as-errors=*
)

endif()