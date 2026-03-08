# 1. Define a unique target name within CMake
set(APP_TARGET "${PROJECT_NAME}_run")

# 2. Create the executable using the variable
add_executable(${APP_TARGET} main.cpp)

# 3. Link to the Universal Alias (Core Library)
target_link_libraries(${APP_TARGET}
    PRIVATE
        ${PROJECT_NAME}::Core
)

# 4. Enforce the "Flat Binary" Output Contract
set_target_properties(${APP_TARGET} PROPERTIES 
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG   "${CMAKE_BINARY_DIR}/bin"
    # This ensures scripts/build.bat and build.sh always find 'app'
    OUTPUT_NAME "app"
)

# 5. Apply your template's strict warning configuration
set_project_warnings(${APP_TARGET})