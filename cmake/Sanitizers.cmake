option(ENABLE_SANITIZERS "Enable sanitizers" OFF)

if(ENABLE_SANITIZERS AND NOT MSVC)

add_compile_options(
    -fsanitize=address
    -fsanitize=undefined
)

add_link_options(
    -fsanitize=address
    -fsanitize=undefined
)

endif()