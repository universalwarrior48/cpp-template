#!/usr/bin/env bash
# Exit on error, undefined vars, or pipe failures
set -euo pipefail

# 1. Arguments & Validation
# Default to linux-gcc if on Linux/WSL, otherwise mingw-gcc
DEFAULT_PRESET="linux-gcc"
if [[ "$(uname -s)" == *"MINGW"* ]] || [[ "$(uname -s)" == *"MSYS"* ]]; then
    DEFAULT_PRESET="mingw-gcc"
fi

BASE_PRESET="${1:-$DEFAULT_PRESET}"
CONFIG="${2:-Debug}"

# Normalize to lowercase for directory and preset matching
CONFIG_LOWER=$(echo "$CONFIG" | tr '[:upper:]' '[:lower:]')
BASE_PRESET_LOWER=$(echo "$BASE_PRESET" | tr '[:upper:]' '[:lower:]')

# Validation: Block MSVC/Clang-cl (they belong in build.bat)
case "$BASE_PRESET_LOWER" in
    mingw-gcc|mingw-clang|linux-gcc|linux-clang)
        ;;
    *)
        echo "ERROR: Unsupported preset '$BASE_PRESET'."
        echo "Use build.bat for MSVC/Clang-CL native Windows builds."
        exit 1
        ;;
esac

# 2. Path & Preset Construction
# Presets in JSON are usually named 'linux-gcc-debug' or 'mingw-gcc-release'
TARGET_PRESET="${BASE_PRESET_LOWER}-${CONFIG_LOWER}"
BUILD_DIR="build/${BASE_PRESET_LOWER}/${CONFIG_LOWER}"

echo "──────────────────────────────────────────────"
echo "[BUILD] Preset: $TARGET_PRESET | Config: $CONFIG"
echo "[DIR]   $BUILD_DIR"
echo "──────────────────────────────────────────────"

# 3. Configure
echo "[STEP 1/3] Configuring preset: $TARGET_PRESET"
cmake --preset "$TARGET_PRESET"

# 4. Build
echo "[STEP 2/3] Building $CONFIG..."
# --parallel automatically detects CPU cores for Ninja/Make
cmake --build "$BUILD_DIR" --config "$CONFIG" --parallel

# 5. Test
echo "[STEP 3/3] Running tests..."
ctest --test-dir "$BUILD_DIR" -C "$CONFIG" --output-on-failure

# 6. Benchmarking (The Flat Binary Contract)
# Check for 'bench' (Linux/WSL) or 'bench.exe' (MSYS2) in the standardized bin folder
BENCH_EXE="$BUILD_DIR/bin/bench"
[ -f "${BENCH_EXE}.exe" ] && BENCH_EXE="${BENCH_EXE}.exe"

if [[ "${CONFIG_LOWER}" == "release" ]] && [[ -f "$BENCH_EXE" ]]; then
    echo "──────────────────────────────────────────────"
    echo "[RUN] Benchmarks: $BENCH_EXE"
    echo "──────────────────────────────────────────────"
    chmod +x "$BENCH_EXE" 2>/dev/null || true
    "$BENCH_EXE" --benchmark_format=console --benchmark_color=true
fi

echo "──────────────────────────────────────────────"
echo "[SUCCESS] Finished $TARGET_PRESET"