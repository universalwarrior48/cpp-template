#include <benchmark/benchmark.h>
#include "core/hello.hpp"

static void BM_Hello(benchmark::State& state)
{
    for (auto _ : state)
    {
        auto s = core::hello();
        benchmark::DoNotOptimize(s);
    }
}

BENCHMARK(BM_Hello);
BENCHMARK_MAIN();