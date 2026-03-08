cmake --preset msvc 
cmake --build build/msvc --config Debug
ctest --test-dir build/msvc -C Debug -V --output-on-failure