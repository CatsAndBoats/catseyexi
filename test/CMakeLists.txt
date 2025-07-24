file(GLOB_RECURSE test_sources CONFIGURE_DEPENDS *.cpp)

add_executable(xi_test
  ${test_sources}
)


find_package(Python3 COMPONENTS Interpreter)

if (${Python3_FOUND})
  # Generate Lua definition files from parsing bindings in C++ files
  set(gen_lua_types_script ${CMAKE_SOURCE_DIR}/tools/generate_lua_types.py)
  set(expected_output ${CMAKE_SOURCE_DIR}/test/scripts/definitions/generated/LuaSimulation.lua) # Just need to list at least one generated output
  file(GLOB cpp_lua_bindings CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/test/lua_*.cpp)
  file(GLOB h_lua_bindings CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/test/lua_*.h)

  add_custom_command(
    OUTPUT ${expected_output}
    COMMAND ${Python3_EXECUTABLE} ${gen_lua_types_script}
    DEPENDS ${cpp_lua_bindings} ${h_lua_bindings} ${gen_lua_types_script}
    COMMENT "Generating Lua definitions"
  )

  add_custom_target(
    gen_lua_types_script_test
    DEPENDS ${expected_output} ${gen_lua_types_script}
  )

  add_dependencies(xi_test gen_lua_types_script_test)
endif()

target_link_libraries(xi_test
  PRIVATE
  xi_game_lib
  argparse
)

setup_post_build(xi_test)
set_target_output_directory(xi_test)
