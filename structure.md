# Project Structure

This document provides an overview of the EliteCppTemplate project structure.

```
EliteCppTemplate/
├── .github/
│   └── workflows/
│       └── ci.yml              # GitHub Actions CI/CD pipeline
├── .gitignore                  # Git ignore rules
├── CMakeLists.txt              # Root CMake configuration
├── CMakePresets.json           # CMake presets for multi-compiler builds
├── README.md                   # Project documentation
│
├── apps/                       # Applications
│   ├── CMakeLists.txt
│   └── app/
│       ├── CMakeLists.txt
│       └── main.cpp            # Application entry point
│
├── libs/                       # Libraries
│   ├── CMakeLists.txt
│   └── core/                   # Core library
│       ├── CMakeLists.txt
│       ├── include/
│       │   └── core/
│       │       └── hello.hpp   # Core library header
│       └── src/
│           └── hello.cpp       # Core library source
│
├── tests/                      # Unit tests
│   ├── CMakeLists.txt
│   └── test_hello.cpp          # Google Test unit tests
│
├── benchmarks/                 # Performance benchmarks
│   ├── CMakeLists.txt
│   └── bench_hello.cpp         # Google Benchmark benchmarks
│
├── cmake/                      # CMake modules
│   ├── CompilerWarnings.cmake  # Compiler warning configuration
│   ├── Sanitizers.cmake        # Sanitizer support (ASan, UBSan)
│   └── StaticAnalyzers.cmake   # clang-tidy integration
│
├── scripts/                    # Build scripts
│   ├── build.bat               # Windows build script
│   ├── build.sh                # Unix build script
│   ├── build_all.bat           # Windows multi-config build
│   └── build_all.sh            # Unix multi-config build
│
└── toolchains/                 # CMake toolchain files (optional)
    ├── mingw-gcc.cmake
    └── mingw-clang.cmake
```

## Directory Overview

| Directory | Description |
|-----------|-------------|
| `.github/workflows/` | CI/CD configuration using GitHub Actions |
| `apps/` | Executable applications |
| `libs/` | Reusable libraries (core library) |
| `tests/` | Unit tests using Google Test |
| `benchmarks/` | Performance benchmarks using Google Benchmark |
| `cmake/` | Reusable CMake modules |
| `scripts/` | Convenience build scripts |
| `toolchains/` | CMake toolchain files for cross-compilation |

## Build System

The project uses **CMake 3.26+** with **C++23** standard.

### CMake Presets

Available presets for different compilers and configurations:

| Preset | Compiler | Type |
|--------|----------|------|
| `msvc-debug` | MSVC | Debug |
| `msvc-release` | MSVC | Release |
| `clang-cl-debug` | Clang-CL | Debug |
| `clang-cl-release` | Clang-CL | Release |
| `mingw-gcc-debug` | MinGW GCC | Debug |
| `mingw-gcc-release` | MinGW GCC | Release |
| `mingw-clang-debug` | MinGW Clang | Debug |
| `mingw-clang-release` | MinGW Clang | Release |
| `linux-gcc-debug` | GCC (Linux) | Debug |
| `linux-gcc-release` | GCC (Linux) | Release |
| `linux-clang-debug` | Clang (Linux) | Debug |
| `linux-clang-release` | Clang (Linux) | Release |

### Build Commands

```bash
# Using CMake Presets (recommended)
cmake --preset msvc-release
cmake --build build/msvc/release

# Using build scripts
./scripts/build.sh              # Unix
.\scripts\build.bat             # Windows

# Run tests
ctest --test-dir build --output-on-failure

# Run benchmarks (Release only)
./build/benchmarks/bench_main
```

## Key Files

- `CMakeLists.txt` - Root CMake configuration that sets up the project
- `CMakePresets.json` - CMake presets for standardized builds across compilers
- `.github/workflows/ci.yml` - Automated CI/CD pipeline
- `cmake/CompilerWarnings.cmake` - Strict compiler warning settings
- `cmake/Sanitizers.cmake` - Address Sanitizer (ASan) and Undefined Behavior Sanitizer (UBSan)
- `cmake/StaticAnalyzers.cmake` - clang-tidy static analysis integration

## Dependencies

- **Google Test** - Unit testing framework
- **Google Benchmark** - Performance benchmarking library

Dependencies are managed via vcpkg (Windows) or can be installed via Conan.