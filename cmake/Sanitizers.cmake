include_guard(GLOBAL)

add_library(project_sanitizers INTERFACE)

option(ENABLE_ADDRESS_SANITIZER "Enable AddressSanitizer (ASan)" OFF)
option(ENABLE_UNDEFINED_SANITIZER "Enable UndefinedBehaviorSanitizer (UBSan)" OFF)

# Sanitizers only work on Clang/GCC, not MSVC
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")

    if(ENABLE_ADDRESS_SANITIZER)
        target_compile_options(project_sanitizers INTERFACE -fsanitize=address)
        target_link_options(project_sanitizers INTERFACE -fsanitize=address)
    endif()

    if(ENABLE_UNDEFINED_SANITIZER)
        target_compile_options(project_sanitizers INTERFACE -fsanitize=undefined)
        target_link_options(project_sanitizers INTERFACE -fsanitize=undefined)
    endif()

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    # MSVC has no built-in sanitizer support via command line
    # Use /fsanitize=address with Clang-CL or external tools
    if(ENABLE_ADDRESS_SANITIZER OR ENABLE_UNDEFINED_SANITIZER)
        message(STATUS "Sanitizers not supported on MSVC. Use Clang-CL or external tooling.")
    endif()

endif()