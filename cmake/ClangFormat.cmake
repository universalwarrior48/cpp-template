include_guard(GLOBAL)

option(ENABLE_AUTO_FORMAT "Run clang-format automatically before build" OFF)

find_program(CLANG_FORMAT_EXE NAMES clang-format)

if(CLANG_FORMAT_EXE)

file(GLOB_RECURSE ALL_SOURCE_FILES
    ${PROJECT_SOURCE_DIR}/libs/**/*.cpp
    ${PROJECT_SOURCE_DIR}/libs/**/*.hpp
    ${PROJECT_SOURCE_DIR}/apps/**/*.cpp
    ${PROJECT_SOURCE_DIR}/apps/**/*.hpp
    ${PROJECT_SOURCE_DIR}/tests/**/*.cpp
    ${PROJECT_SOURCE_DIR}/tests/**/*.hpp
    ${PROJECT_SOURCE_DIR}/benchmarks/**/*.cpp
)

add_custom_target(format
    COMMAND ${CLANG_FORMAT_EXE}
    -i
    ${ALL_SOURCE_FILES}
    COMMENT "Formatting source files with clang-format"
)

# Auto-format before build if enabled
# This sets a variable that subdirectories can use to add dependencies
if(ENABLE_AUTO_FORMAT AND CLANG_FORMAT_EXE)
    # Create format-all target that depends on format
    add_custom_target(format-all
        COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target format
        COMMENT "Running clang-format before build..."
    )
    add_dependencies(format-all format)
    
    set(AUTO_FORMAT_DEP "format-all")
    message(STATUS "Auto-format enabled: clang-format will run before build")
endif()

endif()