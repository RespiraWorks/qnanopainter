cmake_minimum_required(VERSION 3.1 FATAL_ERROR)

project(qnanopainter
  LANGUAGES CXX C
  VERSION 0.0.1)

set(EXTRA_MODULES_DIR ${CMAKE_CURRENT_LIST_DIR}/cmake)
list(APPEND CMAKE_MODULE_PATH ${EXTRA_MODULES_DIR})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})

include(PackageConfig)
include(InstallConfig)
include(EnsureBuildType)
include(CompilerConfig)
include(OutputDirConfig)
include(QtMacFix)

#=============================================================================
# Configurable build options
#=============================================================================

option(QNANO_DEBUG "Enable this to get drawing debug information" OFF)
if(${QNANO_DEBUG})
  add_compile_definitions(QNANO_DEBUG)
endif()

option(QNANO_QT_GL_INCLUDE "Enable this to let Qt include OpenGL headers" ON)
if(${QNANO_QT_GL_INCLUDE})
  add_compile_definitions(QNANO_QT_GL_INCLUDE)
endif()

option(QNANO_ENABLE_GLES3 "This will enable GLES3 (disable to force GLES2)" ON)
if(${QNANO_ENABLE_GLES3})
  add_compile_definitions(QNANO_ENABLE_GLES3)
endif()

option(QNANO_ENABLE_TOUCH_SIGNALS
  "Enable signalling touch events: useful when using view/widget classes directly" OFF)
if(${QNANO_ENABLE_TOUCH_SIGNALS})
  add_compile_definitions(QNANO_ENABLE_TOUCH_SIGNALS)
endif()

option(QNANO_ENABLE_PAINT_SIGNALS
  "Enable signalling paint events: useful when using view/widget classes directly" OFF)
if(${QNANO_ENABLE_PAINT_SIGNALS})
  add_compile_definitions(QNANO_ENABLE_PAINT_SIGNALS)
endif()

option(QNANO_USE_RENDERNODE
  "Enable this to use QRenderNode (Qt>=5.8.0) instead of QQuickFramebufferObject" OFF)
if(${QNANO_USE_RENDERNODE})
  add_compile_definitions(QNANO_USE_RENDERNODE)
endif()

set(QT_VERSION_MAJOR 5)
find_package(QT NAMES Qt5 Qt6 Qt4 COMPONENTS Core QUIET)
message(STATUS "Detected QT major version = ${QT_VERSION_MAJOR}")

# When building for embedded devices you can define manually which backends are supported
option(QNANO_BUILD_GL_BACKENDS "Build with GL backend" OFF)
option(QNANO_BUILD_GLES_BACKENDS "Build with GLES backend" OFF)

# \TODO: win32 link GL libs
# \TODO: Qt6 link GL libs
# \TODO: autoselect backend

if(NOT ${QNANO_BUILD_GLES_BACKENDS} AND NOT ${QNANO_BUILD_GL_BACKENDS})
  message(FATAL_ERROR "No backend selected (QNANO_BUILD_GL_BACKENDS, QNANO_BUILD_GLES_BACKENDS).")
endif()

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/libqnanopainter)

#
# create and install the version file
#
write_basic_package_version_file(
  ${PROJECT_BINARY_DIR}/${PACKAGE_VERSION_FILE_NAME}
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY AnyNewerVersion)

install(FILES ${PROJECT_BINARY_DIR}/${PACKAGE_VERSION_FILE_NAME}
  DESTINATION ${CMAKE_INSTALL_PACKAGEDIR}
  COMPONENT development)

#
# create and install the package file
#
configure_file("${EXTRA_MODULES_DIR}/${PACKAGE_CONFIG_FILE_NAME}.in" ${PACKAGE_CONFIG_FILE_NAME} @ONLY)
install(FILES ${PROJECT_BINARY_DIR}/${PACKAGE_CONFIG_FILE_NAME}
  DESTINATION ${CMAKE_INSTALL_PACKAGEDIR}
  COMPONENT development)

#
# uninstall target
#
if(NOT TARGET uninstall)
  configure_file(
    "${EXTRA_MODULES_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

  add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
endif()
