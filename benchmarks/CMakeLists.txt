find_package(benchmark CONFIG REQUIRED)

add_executable(bench
    bench_hello.cpp
)

target_link_libraries(bench
    PRIVATE
    core
    benchmark::benchmark
)