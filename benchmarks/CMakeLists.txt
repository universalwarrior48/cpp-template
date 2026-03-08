# 1. Find the dependency (VCPKG or Apt handled via root)
find_package(benchmark CONFIG REQUIRED)

# 2. Define the executable
add_executable(bench_hello bench_hello.cpp)

# 3. Link dependencies
target_link_libraries(bench_hello
    PRIVATE
        Elite::Core          # Use the Alias for consistency
        benchmark::benchmark
)

# 4. Standardize output for scripts
# This ensures build.sh and build.bat always find it in /bin/
set_target_properties(bench_hello PROPERTIES 
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    # These 3 lines are the magic fix for MSVC/Multi-config generators:
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}/bin"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG   "${CMAKE_BINARY_DIR}/bin"
    OUTPUT_NAME "bench"
)