# 1. Find GTest (VCPKG/Apt handled via root)
find_package(GTest CONFIG REQUIRED)

# 2. Define the target name based on the project
set(TEST_TARGET "test_${PROJECT_NAME}")

add_executable(${TEST_TARGET} test_hello.cpp)

# 3. Link to the Universal Alias (Core) and GTest
target_link_libraries(${TEST_TARGET}
    PRIVATE
        ${PROJECT_NAME}::Core  # <--- Project-agnostic Alias
        project_options
        project_warnings
        project_sanitizers
        GTest::gtest_main
)

# 4. Enforce the "Flat Binary" Output Contract
set_target_properties(${TEST_TARGET} PROPERTIES 
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG   "${CMAKE_BINARY_DIR}/bin"
    # This makes the file always named 'tests' or 'unit_tests' for scripts
    OUTPUT_NAME "unit_tests" 
)

# 5. Advanced Test Discovery
include(GoogleTest)

gtest_discover_tests(${TEST_TARGET}
    DISCOVERY_MODE PRE_TEST
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    # Ensure DLLs/Shared libs are found on Windows
    ENVIRONMENT "PATH=$<TARGET_FILE_DIR:${TEST_TARGET}>;$ENV{PATH}"
    EXTRA_ARGS --gtest_color=yes
)

# 6. Auto-format before build (if enabled)
if(DEFINED AUTO_FORMAT_DEP)
    add_dependencies(${TEST_TARGET} ${AUTO_FORMAT_DEP})
endif()
