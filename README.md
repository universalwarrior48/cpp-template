# EliteCppTemplate

A production-ready C++ template with modern CMake, testing, benchmarking, and CI/CD.

## Features

- **Modern C++23** with CMake
- **Google Test** for unit testing
- **Google Benchmark** for performance benchmarking
- **CMake Presets** for multi-compiler builds (MSVC, Clang, GCC)
- **Compiler Warnings** configured for strict builds
- **Sanitizers** support (Address, Undefined Behavior)
- **clang-tidy** integration
- **CI/CD** with GitHub Actions

## Quick Start

### Prerequisites

- CMake 3.26+
- C++23 compatible compiler (MSVC 19.29+, GCC 13+, Clang 16+)
- Ninja build system (recommended)

### Build

```bash
# Using CMake Presets (recommended)
cmake --preset msvc
cmake --build build/msvc

# Or using scripts
./scripts/build.sh    # Unix
.\scripts\build.ps1   # Windows PowerShell

# Or manually
cmake -B build -G Ninja
cmake --build build
```

### Test

```bash
ctest --test-dir build
# or
cmake --build build --target test
```

### Benchmark

```bash
./build/benchmarks/bench
```

## Project Structure

```
.
├── apps/              # Applications
│   └── app/
├── libs/              # Libraries
│   └── core/          # Core library
├── tests/             # Unit tests
├── benchmarks/        # Performance benchmarks
├── cmake/             # CMake modules
│   ├── CompilerWarnings.cmake
│   ├── Sanitizers.cmake
│   └── StaticAnalyzers.cmake
├── scripts/           # Build scripts
├── toolchains/        # CMake toolchains
└── .github/
    └── workflows/    # CI/CD
```

## Dependencies

- [Google Test](https://github.com/google/googletest) - Unit testing
- [Google Benchmark](https://github.com/google/benchmark) - Benchmarking

Install via Conan:
```bash
conan install . --output-folder=build --build=missing
```

## Configuration

### CMake Options

| Option | Description | Default |
|--------|-------------|---------|
| `ENABLE_SANITIZERS` | Enable ASan/UBSan | OFF |
| `ENABLE_CLANG_TIDY` | Enable clang-tidy | OFF |

### Presets

| Preset | Compiler | Generator |
|--------|----------|-----------|
| `msvc` | MSVC | Ninja |
| `clang-cl` | Clang-CL | Ninja |
| `mingw-gcc` | MinGW GCC | Ninja |
| `mingw-clang` | MinGW Clang | Ninja |

## License

MIT License