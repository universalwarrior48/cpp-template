cmake_minimum_required(VERSION 3.26)

project(
    EliteCppTemplate
    VERSION 1.0
    DESCRIPTION "Production-grade C++ template"
    LANGUAGES C CXX
)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include(CompilerWarnings)
include(Sanitizers)
include(StaticAnalyzers)

enable_testing()

add_subdirectory(libs)
add_subdirectory(apps)
add_subdirectory(tests)
add_subdirectory(benchmarks)
