 
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

add_executable(simple_3d_viewer main.cpp)

target_include_directories(simple_3d_viewer PRIVATE ../sample_helper_includes)

# Dependencies of this library
target_link_libraries(simple_3d_viewer PRIVATE 
    k4a
    k4arecord
    k4abt
    window_controller_3d::window_controller_3d
    glfw::glfw
    )
