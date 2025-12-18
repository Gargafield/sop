
cmake_minimum_required(VERSION 3.25)

project(SOP VERSION 0.1.0 LANGUAGES C CXX)

add_subdirectory(extern/glfw)
add_subdirectory(extern/glad)
add_subdirectory(extern/glm)

add_executable(SOP.App)

target_sources(
    SOP.App
    PRIVATE
    src/main.cpp
)

target_link_libraries(
    SOP.App
    PRIVATE
    glfw
    glad
    glm
)
