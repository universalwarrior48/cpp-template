add_executable(app
    main.cpp
)

target_link_libraries(app
    PRIVATE
    core
)

set_project_warnings(app)