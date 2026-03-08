@echo off
setlocal EnableDelayedExpansion

:: 1. Arguments & Validation
set "CONFIG=Debug"
if /i "%~2"=="Release" set "CONFIG=Release"

set "BASE_PRESET=msvc"
if not "%~1"=="" set "BASE_PRESET=%~1"

if /i "%BASE_PRESET%" neq "msvc" if /i "%BASE_PRESET%" neq "clang-cl" (
    echo [ERROR] "%BASE_PRESET%" is not a native Windows preset.
    exit /b 1
)

:: 2. Normalize Strings
set "LOWER_CONFIG=!CONFIG:R=r!"
set "LOWER_CONFIG=!LOWER_CONFIG:D=d!"
set "TARGET_PRESET=%BASE_PRESET%-!LOWER_CONFIG!"
set "BUILD_DIR=build\%BASE_PRESET%\!LOWER_CONFIG!"

:: 3. The "VCPKG Nuance" Protection
if "%VCPKG_ROOT%"=="" (echo [ERROR] VCPKG_ROOT not set & exit /b 1)
set "ORIGINAL_VCPKG_ROOT=%VCPKG_ROOT%"

:: Discover VS path dynamically instead of hardcoding 'Community/18'
for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -property installationPath`) do (
    set "VS_PATH=%%i"
)

if /i not "%VSCMD_ARG_TGT_ARCH%"=="x64" (
    echo [INFO] Loading VS Environment...
    :: This is where VS tries to hijack VCPKG_ROOT
    call "!VS_PATH!\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul || exit /b 1
)

:: 4. THE RESTORATION (Blocking the VS hijack)
set "VCPKG_ROOT=%ORIGINAL_VCPKG_ROOT%"
:: Remove the bundled VS vcpkg from PATH if it was added
set "PATH=%PATH:!VS_PATH!\VC\vcpkg\bin;=%"

:: 5. Execution
echo ──────────────────────────────────────────────
echo [BUILD] %TARGET_PRESET% ^(%CONFIG%^)
echo ──────────────────────────────────────────────

:: Using the 'Flat Binary' contract for the bench check
cmake --preset "%TARGET_PRESET%" || exit /b !ERRORLEVEL!
cmake --build "%BUILD_DIR%" --config %CONFIG% --parallel || exit /b !ERRORLEVEL!
ctest --test-dir "%BUILD_DIR%" -C %CONFIG% --output-on-failure

:: 6. Benchmarking (Release Only)
set "BENCH_EXE=%BUILD_DIR%\bin\bench.exe"
if /i "%CONFIG%"=="Release" if exist "!BENCH_EXE!" (
    echo ──────────────────────────────────────────────
    echo [RUN] Benchmarks...
    echo ──────────────────────────────────────────────
    "!BENCH_EXE!" --benchmark_format=console --benchmark_color=true
)

echo ──────────────────────────────────────────────
echo [SUCCESS] Windows build finished.
exit /b 0