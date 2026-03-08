# Build script for cpp-elite-template

$BUILD_DIR = if ($env:BUILD_DIR) { $env:BUILD_DIR } else { "build" }

Write-Host "Building in $BUILD_DIR..."

if (-not (Test-Path $BUILD_DIR)) {
    New-Item -ItemType Directory -Path $BUILD_DIR | Out-Null
}

Push-Location $BUILD_DIR
try {
    cmake .. -DCMAKE_BUILD_TYPE=Release
    cmake --build . --config Release
    Write-Host "Build complete!"
}
finally {
    Pop-Location
}