cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)
project(qnanopainter
  LANGUAGES CXX C
  VERSION 0.0.1
  )

set(EXTRA_MODULES_DIR ${CMAKE_CURRENT_LIST_DIR}/cmake)
list(APPEND CMAKE_MODULE_PATH ${EXTRA_MODULES_DIR})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})

include(EnsureBuildType)
include(CompilerConfig)
include(OutputDirConfig)
include(QtMacFix)

#=============================================================================
# Various build options
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

# When building for embedded devices you can define manually which backends are supported
option(QNANO_BUILD_GL_BACKENDS "Build with GL backend" ON)
option(QNANO_BUILD_GLES_BACKENDS "Build with GLES backend" OFF)

if(NOT ${QNANO_BUILD_GLES_BACKENDS} AND NOT ${QNANO_BUILD_GL_BACKENDS})
  message(FATAL_ERROR "No backend selected. Please enable at least one of QNANO_BUILD_GL_BACKENDS or QNANO_BUILD_GLES_BACKENDS.")
endif()

# \TODO: autodetect backends

set(QT_VERSION_MAJOR 5)
find_package(QT NAMES Qt5 Qt6 Qt4 COMPONENTS Core QUIET)
message(STATUS "Detected QT major version = ${QT_VERSION_MAJOR}")
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui REQUIRED)

# Auto generate moc files
set(CMAKE_AUTORCC ON)

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/libqnanopainter)

