include_guard(GLOBAL)

add_library(project_sanitizers INTERFACE)

option(ENABLE_ADDRESS_SANITIZER "Enable ASan" OFF)
option(ENABLE_UNDEFINED_SANITIZER "Enable UBSan" OFF)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")

    if(ENABLE_ADDRESS_SANITIZER)
        target_compile_options(project_sanitizers INTERFACE -fsanitize=address)
        target_link_options(project_sanitizers INTERFACE -fsanitize=address)
    endif()

    if(ENABLE_UNDEFINED_SANITIZER)
        target_compile_options(project_sanitizers INTERFACE -fsanitize=undefined)
        target_link_options(project_sanitizers INTERFACE -fsanitize=undefined)
    endif()

endif()