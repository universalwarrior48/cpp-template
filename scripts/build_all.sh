#!/usr/bin/env bash
set -euo pipefail

# 1. Environment Detection
IS_MSYS=false
TARGET_ENV="Linux/WSL" # Default

if [[ "$(uname -s)" == *"MINGW"* ]] || [[ "$(uname -s)" == *"MSYS"* ]]; then
    IS_MSYS=true
    TARGET_ENV="MSYS2/MinGW"
    echo "[INFO] MSYS2/MinGW Environment Detected"
else
    echo "[INFO] Linux/WSL Environment Detected"
fi

# 2. Define the Matrix
CONFIGS=("Debug" "Release")

# Auto-format support (pass as argument, e.g., ./build_all.sh ON)
AUTO_FORMAT="${1:-OFF}"

if [ "$IS_MSYS" = true ]; then
    PRESETS=("mingw-gcc" "mingw-clang")
else
    PRESETS=("linux-gcc" "linux-clang")
fi

# 3. Execution Loop
echo "──────────────────────────────────────────────"
echo "🚀 STARTING MASTER BUILD MATRIX: $TARGET_ENV"
echo "──────────────────────────────────────────────"

# Get the directory where THIS script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for preset in "${PRESETS[@]}"; do
    for config in "${CONFIGS[@]}"; do
        echo ""
        echo "⚒️  Building Node: $preset | $config"
        
        # Use SCRIPT_DIR to find build.sh reliably
        bash "$SCRIPT_DIR/build.sh" "$preset" "$config" "$AUTO_FORMAT"
        
        echo "✅ Finished: $preset-$config"
    done
done

echo ""
echo "──────────────────────────────────────────────"
echo "🎉 BOOYA! All $TARGET_ENV builds successful."
echo "──────────────────────────────────────────────"