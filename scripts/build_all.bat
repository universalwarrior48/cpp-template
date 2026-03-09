@echo off
setlocal EnableDelayedExpansion

:: 1. Define the Windows Matrix (native tools only - msvc/clang-cl)
:: For mingw builds, use ucrt64 shell with build.sh
set "COMPILERS=msvc clang-cl"
set "CONFIGS=Debug Release"

:: Auto-format support (pass as argument, e.g., build_all.bat ON)
set "AUTO_FORMAT=OFF"
if /i "%~1"=="ON" set "AUTO_FORMAT=ON"

echo =================================================
echo [MASTER BUILD] Testing all Windows Configurations
echo [AUTO_FORMAT=%AUTO_FORMAT%]
echo =================================================

:: 2. Execution Loop
for %%c in (%COMPILERS%) do (
    for %%g in (%CONFIGS%) do (
        echo.
        echo ──────────────────────────────────────────────
        echo [TASK] Starting Matrix Node: %%c-%%g
        echo ──────────────────────────────────────────────
        
        :: %~dp0 is the directory of THIS script. 
        :: We wrap it in quotes to handle spaces in folder names.
        if exist "%~dp0build.bat" (
            call "%~dp0build.bat" %%c %%g %AUTO_FORMAT%
        ) else (
            echo [ERROR] Could not find build.bat in %~dp0
            exit /b 1
        )
        
        if !ERRORLEVEL! neq 0 (
            echo.
            echo [ERROR] Matrix failure at %%c-%%g.
            exit /b !ERRORLEVEL!
        )
    )
)

echo.
echo =================================================
echo [SUCCESS] All 4 Windows configurations passed!
echo =================================================
pause