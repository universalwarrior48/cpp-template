# --- Target Definition ---
add_library(${MY_LIB_NAME} src/hello.cpp)
add_library(${PROJECT_NAME}::Core ALIAS ${MY_LIB_NAME})

# --- Link to Global Options, Warnings, and Sanitizers ---
target_link_libraries(${MY_LIB_NAME}
    PRIVATE
        project_options
        project_warnings
        project_sanitizers
)

# --- Clang-Tidy Integration ---
if(COMMAND enable_clang_tidy)
    enable_clang_tidy(${MY_LIB_NAME})
endif()

# --- Include Directories ---
target_include_directories(${MY_LIB_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

# --- Auto-format before build (if enabled) ---
if(DEFINED AUTO_FORMAT_DEP)
    add_dependencies(${MY_LIB_NAME} ${AUTO_FORMAT_DEP})
endif()

# --- Compiler Tooling ---
# Assuming your include(CompilerWarnings) defines this function
#set_project_warnings(${MY_LIB_NAME})