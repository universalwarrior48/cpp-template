# 1. Find the dependency (VCPKG or Apt handled via root)
find_package(benchmark CONFIG REQUIRED)


# 2. Define the executable
set(BENCH_TARGET "bench_${PROJECT_NAME}")
add_executable(${BENCH_TARGET} bench_hello.cpp)

# 3. Link dependencies
target_link_libraries(${BENCH_TARGET}
    PRIVATE
        ${PROJECT_NAME}::Core          # Use the Alias for consistency
        project_options
        project_warnings
        benchmark::benchmark
)

# 4. Standardize output for scripts
# This ensures build.sh and build.bat always find it in /bin/
set_target_properties(${BENCH_TARGET} PROPERTIES 
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG   "${CMAKE_BINARY_DIR}/bin"
    OUTPUT_NAME "bench"
)