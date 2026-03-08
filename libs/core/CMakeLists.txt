# --- Target Definition ---
add_library(${MY_LIB_NAME} src/hello.cpp)
add_library(${PROJECT_NAME}::Core ALIAS ${MY_LIB_NAME})

# --- Include Directories ---
target_include_directories(${MY_LIB_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

# --- Compiler Tooling ---
# Assuming your include(CompilerWarnings) defines this function
set_project_warnings(${MY_LIB_NAME})