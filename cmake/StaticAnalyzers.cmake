include_guard(GLOBAL)

#option(ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)

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