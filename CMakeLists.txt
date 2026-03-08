cmake_minimum_required(VERSION 3.26)

# -----------------------------------------------------------------------------
# 1. Project Setup
# -----------------------------------------------------------------------------
project(
    EliteCppTemplate
    VERSION 1.0.0
    DESCRIPTION "Production-grade C++23 template for cross-platform development"
    LANGUAGES C CXX
)

# Set global C++ standard
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Enable compile_commands.json for Clang-Tidy/LSP (VS Code) support
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# -----------------------------------------------------------------------------
# 2. Global Options & Modules
# -----------------------------------------------------------------------------
option(BUILD_BENCHMARKS "Build performance benchmarks" OFF)
option(BUILD_TESTS      "Build unit tests"            ON)
option(BUILD_SHARED_LIBS "Build libraries as shared"   OFF)

# Extend module path to find custom scripts in /cmake
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

# Include Professional Tooling Modules
include(CompilerWarnings)  # Sets strict warnings per compiler
include(Sanitizers)        # Configures ASan/UBSan
include(StaticAnalyzers)   # Configures Clang-Tidy/IWYU

# -----------------------------------------------------------------------------
# 3. Target Orchestration
# -----------------------------------------------------------------------------

# Add Libraries (Core logic)
add_subdirectory(libs)

# Add Applications (Main entry points)
add_subdirectory(apps)

# -----------------------------------------------------------------------------
# 4. Testing & Benchmarking (Conditional)
# -----------------------------------------------------------------------------
if(BUILD_TESTS)
    message(STATUS "[EliteTemplate] Unit Tests Enabled")
    enable_testing()
    add_subdirectory(tests)
endif()

if(BUILD_BENCHMARKS)
    message(STATUS "[EliteTemplate] Benchmarks Enabled")
    add_subdirectory(benchmarks)
endif()

# -----------------------------------------------------------------------------
# 5. Summary (Booya!)
# -----------------------------------------------------------------------------
message(STATUS "-----------------------------------------------------------")
message(STATUS " Project:      ${PROJECT_NAME}")
message(STATUS " Version:      ${PROJECT_VERSION}")
message(STATUS " Compiler:     ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS " Build Type:   ${CMAKE_BUILD_TYPE}")
message(STATUS " Benchmarks:   ${BUILD_BENCHMARKS}")
message(STATUS " Tests:        ${BUILD_TESTS}")
message(STATUS "-----------------------------------------------------------")