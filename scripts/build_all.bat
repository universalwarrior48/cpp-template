@echo off
setlocal EnableDelayedExpansion

:: 1. Define the Windows Matrix
set "COMPILERS=msvc clang-cl"
set "CONFIGS=Debug Release"

echo =================================================
echo [MASTER BUILD] Testing all Windows Configurations
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
            call "%~dp0build.bat" %%c %%g
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