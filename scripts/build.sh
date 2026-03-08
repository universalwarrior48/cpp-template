#!/usr/bin/env bash
set -euo pipefail

PRESET="${1:-mingw-gcc}"

case "$PRESET" in
    mingw-gcc|mingw-clang)
        ;;
    *)
        echo "ERROR: This script is for MinGW presets only."
        exit 1
        ;;
esac

echo "=== Configuring: $PRESET ==="
cmake --preset "$PRESET"

echo "=== Building Debug ==="
# Instead of --preset, use the binary dir directly (matches your preset definition)
cmake --build "build/$PRESET" --config Debug

echo "=== Running tests ==="
ctest --test-dir "build/$PRESET" -C Debug -V --output-on-failure

echo "Success! $PRESET"