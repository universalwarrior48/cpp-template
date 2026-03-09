
# 🚀 Elite C++ Template

![CI Status](https://github.com/universalwarrior48/cpp-template/actions/workflows/ci.yml/badge.svg)

A production-ready C++20 template for Windows (MSVC/Clang-CL), Linux (GCC/Clang), and MSYS2 (MinGW).

## ✨ Key Features
- **C++20 Standard**: Modern C++ with modules, concepts, and ranges support.
- **Multi-Compiler Support**: MSVC, Clang-CL, MinGW GCC, MinGW Clang, Linux GCC, Linux Clang.
- **CMake Presets**: Standardized builds across all compilers and configurations.
- **Testing & Benchmarking**: Google Test for unit tests, Google Benchmark for performance.
- **Quality Tools**: Clang-Tidy static analysis, sanitizer support (ASan/UBSan), clang-format.

## 📁 Project Structure
```
.
├── apps/               # Executables (e.g., app/main.cpp)
├── libs/               # Modular libraries (Elite::Core)
├── tests/              # Google Test suite
├── benchmarks/         # Google Benchmark suite
├── cmake/              # Modules: CompilerWarnings, Sanitizers, StaticAnalyzers
├── scripts/            # Build automation (build.bat, build.sh, build_all.*)
├── .github/workflows/  # CI/CD pipeline
├── CMakePresets.json   # CMake presets for all compilers
└── vcpkg.json          # Dependency manifest (Windows)
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

### Using CMake Presets (Recommended)

```bash
# Configure with preset
cmake --preset msvc-release    # Windows MSVC
cmake --preset linux-gcc-debug # Linux/WSL

# Build
cmake --build build/msvc/release

# Test
ctest --test-dir build/msvc/release --output-on-failure
```

### Using Build Scripts

```powershell
.\scripts\build.bat msvc Release    # Windows
./scripts/build.sh linux-gcc Debug  # Linux/WSL/MSYS2
```

### Master Build (All Configurations)

```powershell
.\scripts\build_all.bat   # Windows
./scripts/build_all.sh    # Linux/WSL/MSYS2
```

## 📈 Benchmarking & Testing

* **Unit Tests**: Run via `ctest --test-dir <build-dir>`
* **Benchmarks**: Automatically execute in **Release** mode when using build scripts
* **Output**: Binaries land in `build/<preset>/<config>/bin/`

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