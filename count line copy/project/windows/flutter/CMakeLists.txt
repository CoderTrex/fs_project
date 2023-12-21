# This file controls Flutter-level build steps. It should not be edited.
cmake_minimum_required(VERSION 3.14)

set(EPHEMERAL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ephemeral")

# Configuration provided via flutter tool.
include(${EPHEMERAL_DIR}/generated_config.cmake)

# TODO: Move the rest of this into files in ephemeral. See
# https://github.com/flutter/flutter/issues/57146.
set(WRprojectER_ROOT "${EPHEMERAL_DIR}/cpp_client_wrprojecter")

# Set fallback configurations for older versions of the flutter tool.
if (NOT DEFINED FLUTTER_TARGET_PLATFORM)
  set(FLUTTER_TARGET_PLATFORM "windows-x64")
endif()

# === Flutter Library ===
set(FLUTTER_LIBRARY "${EPHEMERAL_DIR}/flutter_windows.dll")

# Published to parent scope for install step.
set(FLUTTER_LIBRARY ${FLUTTER_LIBRARY} PARENT_SCOPE)
set(FLUTTER_ICU_DATA_FILE "${EPHEMERAL_DIR}/icudtl.dat" PARENT_SCOPE)
set(PROJECT_BUILD_DIR "${PROJECT_DIR}/build/" PARENT_SCOPE)
set(AOT_LIBRARY "${PROJECT_DIR}/build/windows/project.so" PARENT_SCOPE)

list(projectEND FLUTTER_LIBRARY_HEADERS
  "flutter_export.h"
  "flutter_windows.h"
  "flutter_messenger.h"
  "flutter_plugin_registrar.h"
  "flutter_texture_registrar.h"
)
list(TRANSFORM FLUTTER_LIBRARY_HEADERS PREPEND "${EPHEMERAL_DIR}/")
add_library(flutter INTERFACE)
target_include_directories(flutter INTERFACE
  "${EPHEMERAL_DIR}"
)
target_link_libraries(flutter INTERFACE "${FLUTTER_LIBRARY}.lib")
add_dependencies(flutter flutter_assemble)

# === Wrprojecter ===
list(projectEND CPP_WRprojectER_SOURCES_CORE
  "core_implementations.cc"
  "standard_codec.cc"
)
list(TRANSFORM CPP_WRprojectER_SOURCES_CORE PREPEND "${WRprojectER_ROOT}/")
list(projectEND CPP_WRprojectER_SOURCES_PLUGIN
  "plugin_registrar.cc"
)
list(TRANSFORM CPP_WRprojectER_SOURCES_PLUGIN PREPEND "${WRprojectER_ROOT}/")
list(projectEND CPP_WRprojectER_SOURCES_project
  "flutter_engine.cc"
  "flutter_view_controller.cc"
)
list(TRANSFORM CPP_WRprojectER_SOURCES_project PREPEND "${WRprojectER_ROOT}/")

# Wrprojecter sources needed for a plugin.
add_library(flutter_wrprojecter_plugin STATIC
  ${CPP_WRprojectER_SOURCES_CORE}
  ${CPP_WRprojectER_SOURCES_PLUGIN}
)
projectly_standard_settings(flutter_wrprojecter_plugin)
set_target_properties(flutter_wrprojecter_plugin PROPERTIES
  POSITION_INDEPENDENT_CODE ON)
set_target_properties(flutter_wrprojecter_plugin PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_link_libraries(flutter_wrprojecter_plugin PUBLIC flutter)
target_include_directories(flutter_wrprojecter_plugin PUBLIC
  "${WRprojectER_ROOT}/include"
)
add_dependencies(flutter_wrprojecter_plugin flutter_assemble)

# Wrprojecter sources needed for the runner.
add_library(flutter_wrprojecter_project STATIC
  ${CPP_WRprojectER_SOURCES_CORE}
  ${CPP_WRprojectER_SOURCES_project}
)
projectly_standard_settings(flutter_wrprojecter_project)
target_link_libraries(flutter_wrprojecter_project PUBLIC flutter)
target_include_directories(flutter_wrprojecter_project PUBLIC
  "${WRprojectER_ROOT}/include"
)
add_dependencies(flutter_wrprojecter_project flutter_assemble)

# === Flutter tool backend ===
# _phony_ is a non-existent file to force this command to run every time,
# since currently there's no way to get a full input/output list from the
# flutter tool.
set(PHONY_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/_phony_")
set_source_files_properties("${PHONY_OUTPUT}" PROPERTIES SYMBOLIC TRUE)
add_custom_command(
  OUTPUT ${FLUTTER_LIBRARY} ${FLUTTER_LIBRARY_HEADERS}
    ${CPP_WRprojectER_SOURCES_CORE} ${CPP_WRprojectER_SOURCES_PLUGIN}
    ${CPP_WRprojectER_SOURCES_project}
    ${PHONY_OUTPUT}
  COMMAND ${CMAKE_COMMAND} -E env
    ${FLUTTER_TOOL_ENVIRONMENT}
    "${FLUTTER_ROOT}/packages/flutter_tools/bin/tool_backend.bat"
      ${FLUTTER_TARGET_PLATFORM} $<CONFIG>
  VERBATIM
)
add_custom_target(flutter_assemble DEPENDS
  "${FLUTTER_LIBRARY}"
  ${FLUTTER_LIBRARY_HEADERS}
  ${CPP_WRprojectER_SOURCES_CORE}
  ${CPP_WRprojectER_SOURCES_PLUGIN}
  ${CPP_WRprojectER_SOURCES_project}
)
