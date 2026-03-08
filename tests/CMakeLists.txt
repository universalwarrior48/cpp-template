find_package(GTest CONFIG REQUIRED)

add_executable(unit_tests
    test_hello.cpp
)

target_link_libraries(unit_tests
    PRIVATE
    core
    GTest::gtest_main
)

set(CMAKE_GTEST_DISCOVER_TESTS_DISCOVERY_MODE PRE_TEST)

include(GoogleTest)

gtest_discover_tests(unit_tests
    DISCOVERY_MODE PRE_TEST
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    ENVIRONMENT "PATH=$<TARGET_FILE_DIR:core>;$ENV{PATH}"
    EXTRA_ARGS --gtest_color=yes
)