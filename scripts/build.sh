#!/usr/bin/env bash
# Exit on error, undefined vars, or pipe failures
set -euo pipefail

# 1. Arguments & Validation
BASE_PRESET="${1:-mingw-gcc}"
CONFIG="${2:-Debug}"

# Ensure we use lowercase for paths/presets (e.g., "Release" -> "release")
CONFIG_LOWER=$(echo "$CONFIG" | tr '[:upper:]' '[:lower:]')
BASE_PRESET_LOWER=$(echo "$BASE_PRESET" | tr '[:upper:]' '[:lower:]')

# Validation: Only allow MinGW or Linux presets for this script
case "$BASE_PRESET_LOWER" in
    mingw-gcc|mingw-clang|linux-gcc|linux-clang)
        ;;
    *)
        echo "ERROR: Unsupported preset '$BASE_PRESET'."
        echo "This script is for MinGW or Linux presets. Use build.bat for MSVC/Clang-CL."
        exit 1
        ;;
esac

# 2. Dynamic Path/Preset Construction
TARGET_PRESET="${BASE_PRESET_LOWER}-${CONFIG_LOWER}"
BUILD_DIR="build/${BASE_PRESET_LOWER}/${CONFIG_LOWER}"

echo "──────────────────────────────────────────────"
echo "[BUILD] Preset: $TARGET_PRESET | Config: $CONFIG"
echo "[DIR]   $BUILD_DIR"
echo "──────────────────────────────────────────────"

# 3. Configure
echo "[STEP 1/3] Configuring with preset: $TARGET_PRESET"
cmake --preset "$TARGET_PRESET"

# 4. Build
echo "[STEP 2/3] Building $CONFIG..."
# Using --parallel to speed up MinGW/Linux builds
cmake --build "$BUILD_DIR" --config "$CONFIG" --parallel

# 5. Test
echo "[STEP 3/3] Running tests..."
ctest --test-dir "$BUILD_DIR" -C "$CONFIG" --output-on-failure

echo "──────────────────────────────────────────────"
echo "[SUCCESS] Finished $TARGET_PRESET"