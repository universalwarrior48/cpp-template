#!/usr/bin/env bash
set -e

# Detect if we are on MinGW/UCRT or Native Linux to set prefix
if [[ "$MSYSTEM" == "UCRT64" ]]; then
    COMPILERS="mingw-gcc mingw-clang"
else
    COMPILERS="linux-gcc linux-clang"
fi

CONFIGS="Debug Release"

echo "================================================="
echo "[MASTER BUILD] Testing all Unix-style Configurations"
echo "================================================="

for comp in $COMPILERS; do
    for conf in $CONFIGS; do
        echo ""
        echo "[TASK] Starting $comp-$conf..."
        
        # Call your existing build script
        ./scripts/build.sh "$comp" "$conf"
        
        echo "[OK] $comp-$conf passed."
    done
done

echo ""
echo "================================================="
echo "[SUCCESS] All 4 configurations passed!"
echo "================================================="