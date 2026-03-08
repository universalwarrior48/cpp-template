# --- Target Definition ---
add_library(core src/hello.cpp)
add_library(Elite::Core ALIAS core)

# --- Include Directories ---
target_include_directories(core
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

# --- Compiler Tooling ---
# Assuming your include(CompilerWarnings) defines this function
set_project_warnings(core)