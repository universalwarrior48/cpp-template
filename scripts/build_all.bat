@echo off
setlocal EnableDelayedExpansion

:: Define our Windows target matrix
set "COMPILERS=msvc clang-cl"
set "CONFIGS=Debug Release"

echo =================================================
echo [MASTER BUILD] Testing all Windows Configurations
echo =================================================

for %%c in (%COMPILERS%) do (
    for %%g in (%CONFIGS%) do (
        echo.
        echo [TASK] Starting %%c-%%g...
        
        :: Call your existing build script for each combination
        call .\scripts\build.bat %%c %%g
        
        if !ERRORLEVEL! neq 0 (
            echo.
            echo [ERROR] Build failed for %%c-%%g. Aborting.
            exit /b !ERRORLEVEL!
        )
    )
)

echo.
echo =================================================
echo [SUCCESS] All 4 Windows configurations passed!
echo =================================================
pause