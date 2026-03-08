
# 🚀 Elite C++ Template

![CI Status](https://github.com/universalwarrior48/cpp-template/actions/workflows/ci.yml/badge.svg)

A high-performance C++23 template for Windows (MSVC), WSL2 (GCC/Clang), and MSYS2.

A production-ready C++23 template featuring modern CMake, strict compiler enforcement, and a cross-platform matrix (Windows, UCRT64, WSL2).

## ✨ Key Features
- **C++23 Standard**: Native support for the latest language features.
- **Triple-Environment**: Standardized builds for MSVC/Clang-cl, MSYS2/UCRT64, and Lean WSL2.
- **Automated Matrix**: `build_all` scripts testing 8 distinct configurations.
- **Performance First**: Google Benchmark integrated into the Release cycle.
- **Strict Quality**: Custom modules for Warnings, Sanitizers, and Clang-Tidy.

## 📁 Project Structure
```
.
├── apps/               # Executables (e.g., app/main.cpp)
├── libs/               # Modular libraries (Elite::Core)
├── tests/              # Google Test suite
├── benchmarks/         # Google Benchmark suite
├── cmake/              # Modules: CompilerWarnings, Sanitizers, StaticAnalyzers
├── scripts/            # Build automation (build.bat, build.sh, build_all.*)
└── vcpkg.json          # Dependency manifest mode
```

## 🛠 Prerequisites

### 1. Windows Native

* **Visual Studio 2022+** (Desktop C++ workload).
* **vcpkg**: Set `VCPKG_ROOT` in your environment variables.

### 2. MSYS2 (UCRT64)

In the **UCRT64 Terminal**, install the toolchain:

```bash
pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-clang \
          mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-ninja \
          mingw-w64-ucrt-x86_64-gtest mingw-w64-ucrt-x86_64-google-benchmark

```

### 3. WSL2 (Lean Ubuntu - 15GB Cap)

* **WSL Config**: In `%USERPROFILE%\.wslconfig`, add `[wsl2] sparseVhd=true`.
* **Mount Fix**: In WSL `/etc/wsl.conf`, add `[automount] options = "metadata"`.
* **Install**:

```bash
sudo apt update && sudo apt install -y --no-install-recommends \
    gcc g++ clang cmake ninja-build libgtest-dev libbenchmark-dev

```

## ⚡ Build System

### Standard Build (Individual)

```powershell
.\scripts\build.bat msvc Release    # Windows
./scripts/build.sh linux-gcc Debug  # WSL/Linux

```

### Master Build (The Matrix)

Runs all 4 compiler configurations (Debug + Release) in one go.

```powershell
.\scripts\build_all.bat   # Windows Native
./scripts/build_all.sh    # UCRT64 or WSL

```

## 📈 Benchmarking & Testing

* **Unit Tests**: Run on every build via `ctest`.
* **Benchmarks**: Automatically execute in **Release** mode only.
* **Output**: Binaries land in `build/<preset>/bin/` for easy script access.

## 🧹 Maintenance

To reset your environment and clear all build folders:

```powershell
# VS Code Task: Master: Clean All Builds
if exist build (rd /s /q build)

```


# Benchmarking Example
### `benchmarks/bench_hello.cpp` (The working example)

This file demonstrates how to benchmark the `hello` function from your `Elite::Core` library.

```cpp
#include <benchmark/benchmark.h>
#include <core/hello.hpp> // Assumes your include/core/hello.hpp exists
#include <string>
#include <vector>

// 1. Benchmark a simple function from your library
static void BM_HelloFunction(benchmark::State& state) {
    // Optional: Setup code here
    for (auto _ : state) {
        // This is the code we are measuring
        std::string result = get_hello_message(); 
        benchmark::DoNotOptimize(result);
    }
}
BENCHMARK(BM_HelloFunction);

// 2. Benchmark with Arguments (e.g., measuring performance scaling)
static void BM_StringCopy(benchmark::State& state) {
    std::string x = "EliteCppTemplate Performance Test";
    for (auto _ : state) {
        for (int i = 0; i < state.range(0); ++i) {
            std::string copy = x;
            benchmark::DoNotOptimize(copy);
        }
    }
    state.SetComplexityN(state.range(0));
}
// Run this benchmark for 10, 100, and 1000 iterations
BENCHMARK(BM_StringCopy)->Arg(10)->Arg(100)->Arg(1000)->Complexity();

// 3. Main entry point provided by Google Benchmark
BENCHMARK_MAIN();

```

## ⚖ License

MIT License