include_guard(GLOBAL)

option(BUILD_BENCHMARKS  "Build performance benchmarks" OFF)
option(BUILD_TESTS       "Build unit tests" ON)
option(BUILD_SHARED_LIBS "Build libraries as shared" OFF)
option(ENABLE_CLANG_TIDY "Enable clang-tidy static analysis" OFF)
option(ENABLE_IPO "Enable Interprocedural Optimization (LTO)" OFF)
option(ENABLE_WARNINGS_AS_ERRORS "Treat warnings as errors" OFF)
option(ENABLE_SANITIZERS "Enable sanitizers (ASan/UBSan)" OFF)

add_library(project_options INTERFACE)

# Require modern C++
target_compile_features(project_options INTERFACE cxx_std_20)

# Allow users to opt-in to C++23 features if desired
# target_compile_features(project_options INTERFACE cxx_std_23)

# LTO / IPO
include(CheckIPOSupported)

if(ENABLE_IPO)
    check_ipo_supported(RESULT ipo_supported OUTPUT error)

    if(ipo_supported)
        set_property(TARGET project_options PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
    endif()
endif()

# warnings as errors
if(ENABLE_WARNINGS_AS_ERRORS)
    target_compile_options(project_options INTERFACE
        $<$<CXX_COMPILER_ID:Clang,GNU>:-Werror>
        $<$<CXX_COMPILER_ID:MSVC>:/WX>
    )
endif()