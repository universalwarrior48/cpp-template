@echo off
setlocal EnableDelayedExpansion

set "CONFIG=Debug"
if /i "%~2"=="Release" set "CONFIG=Release"

if "%VCPKG_ROOT%"=="" (
    echo [ERROR] VCPKG_ROOT is not set. 
    echo Please set it to your vcpkg installation directory.
    exit /b 1
)

:: Cache the VCPKG_ROOT
set "VCPKG_ROOT_CACHED=%VCPKG_ROOT%"

echo [INFO] Using configuration: %CONFIG%
:: ────────────────────────────────────────────────
:: Environment Config
:: ────────────────────────────────────────────────
set "VS_YEAR=2026"
set "VS_VERSION=18"
if "%VS_YEAR%"=="2022" set "VS_VERSION=17"
set "VS_EDITION=Community"

:: Use vswhere.exe if available for a more robust search, 
:: but sticking to your path-based logic for simplicity:
set "VS_VCVARS=C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\%VS_EDITION%\VC\Auxiliary\Build\vcvarsall.bat"

if not exist "%VS_VCVARS%" (
    echo [ERROR] vcvarsall.bat not found at: "%VS_VCVARS%"
    exit /b 1
)

:: ────────────────────────────────────────────────
:: Load VS Environment (Idempotent)
:: ────────────────────────────────────────────────
if "%VSCMD_ARG_TGT_ARCH%"=="x64" (
    echo [INFO] VS Environment already loaded.
) else (
    echo [INFO] Loading VS %VS_YEAR% x64 environment...
    :: Use 'call' directly to keep environment variables in the current process
    call "%VS_VCVARS%" x64
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] vcvarsall.bat failed with code !ERRORLEVEL!
        exit /b !ERRORLEVEL!
    )
)

:: Check vcpkg.exe path again after loading VS environment, as it may affect PATH:
echo [INFO] Checking for vcpkg.exe in PATH...
set VCPKG_ROOT=%VCPKG_ROOT_CACHED%
set CMAKE_TOOLCHAIN_FILE=%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake
set PATH=%PATH:C:\Program Files\Microsoft Visual Studio\18\Community\VC\vcpkg\bin;=%

:: ────────────────────────────────────────────────
:: Preset Handling & Execution
:: ────────────────────────────────────────────────
set "PRESET=msvc"
if not "%~1"=="" set "PRESET=%~1"

:: Validation
if /i "%PRESET%" neq "msvc" if /i "%PRESET%" neq "clang-cl" (
    echo [ERROR] Unsupported preset "%PRESET%". Use 'msvc' or 'clang-cl'.
    exit /b 1
)

echo [INFO] Configuring with preset: %PRESET%
cmake --preset "%PRESET%" || exit /b !ERRORLEVEL!

echo [INFO] Building %CONFIG%...
cmake --build "build/%PRESET%" --config %CONFIG% || exit /b !ERRORLEVEL!

echo [INFO] Running tests...
ctest --test-dir "build/%PRESET%" -C %CONFIG% -V --output-on-failure || (
    echo [WARN] Tests failed.
    exit /b 1
)

echo [SUCCESS] Build and tests completed for %PRESET%.
exit /b 0