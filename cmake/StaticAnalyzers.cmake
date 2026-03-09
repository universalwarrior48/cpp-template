include_guard(GLOBAL)

# Note: ENABLE_CLANG_TIDY option is defined in ProjectOptions.cmake

function(enable_clang_tidy target)

    if(NOT ENABLE_CLANG_TIDY)
        return()
    endif()

    find_program(CLANG_TIDY_EXE NAMES clang-tidy)

    if(CLANG_TIDY_EXE)
        set_target_properties(${target} PROPERTIES
            CXX_CLANG_TIDY
            "${CLANG_TIDY_EXE};-checks=*;-warnings-as-errors=*"
        )
    endif()

endfunction()