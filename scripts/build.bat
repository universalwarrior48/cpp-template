@echo off
setlocal EnableDelayedExpansion

:: 1. Arguments & Windows-Specific Validation
set "CONFIG=Debug"
if /i "%~2"=="Release" set "CONFIG=Release"

set "BASE_PRESET=msvc"
if not "%~1"=="" set "BASE_PRESET=%~1"

if /i "%BASE_PRESET%" neq "msvc" if /i "%BASE_PRESET%" neq "clang-cl" (
    echo [ERROR] "%BASE_PRESET%" is not a native Windows preset.
    echo Please use build.sh for MinGW or Linux builds.
    exit /b 1
)

:: 2. Build Internal Strings (Preset names are lowercase in JSON)
set "TARGET_PRESET=%BASE_PRESET%-%CONFIG%"
set "TARGET_PRESET=!TARGET_PRESET:D=d!" & set "TARGET_PRESET=!TARGET_PRESET:R=r!"
set "BUILD_DIR=build/%BASE_PRESET%/!CONFIG:D=d!" & set "BUILD_DIR=!BUILD_DIR:R=r!"

:: 3. VS Environment & VCPKG Cache
if "%VCPKG_ROOT%"=="" (echo [ERROR] VCPKG_ROOT not set & exit /b 1)
set "VCPKG_ROOT_CACHED=%VCPKG_ROOT%"

set "VS_VERSION=18"
set "VS_EDITION=Community"
set "VS_VCVARS=C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\%VS_EDITION%\VC\Auxiliary\Build\vcvarsall.bat"

if /i not "%VSCMD_ARG_TGT_ARCH%"=="x64" (
    echo [INFO] Loading VS %VS_VERSION% x64 environment...
    call "%VS_VCVARS%" x64 >nul || exit /b 1
)

:: Restore Env
set "VCPKG_ROOT=%VCPKG_ROOT_CACHED%"
set "PATH=%PATH:C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\%VS_EDITION%\VC\vcpkg\bin;=%"

:: 4. Execution
echo ──────────────────────────────────────────────
echo [BUILD] %TARGET_PRESET% ^(%CONFIG%^)
echo ──────────────────────────────────────────────

cmake --preset "%TARGET_PRESET%" || exit /b !ERRORLEVEL!
cmake --build "%BUILD_DIR%" --config %CONFIG% --parallel || exit /b !ERRORLEVEL!
ctest --test-dir "%BUILD_DIR%" -C %CONFIG% --output-on-failure


:: ────────────────────────────────────────────────
:: 4. Benchmarking (Release Only)
:: ────────────────────────────────────────────────
set "BENCH_EXE=%BUILD_DIR%\bin\bench.exe"
if /i "%CONFIG%"=="Release" if exist "%BENCH_EXE%" (
    echo Running Benchmarks...
    "%BENCH_EXE%" --benchmark_format=console --benchmark_color=true
)

echo ──────────────────────────────────────────────
echo [SUCCESS] Windows build finished.
exit /b 0