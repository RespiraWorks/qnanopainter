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

set(this_target QNanoPainter)

set(QT_VERSION_MAJOR 5)
find_package(QT NAMES Qt5 Qt6 Qt4 COMPONENTS Core QUIET)
message(STATUS "Detected QT major version = ${QT_VERSION_MAJOR}")
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui REQUIRED)

# Auto generate moc files
set(CMAKE_AUTORCC ON)

set(${this_target}_sources
  libqnanopainter
  libqnanopainter/qnanopainter.cpp
  libqnanopainter/qnanocolor.cpp
  libqnanopainter/qnanolineargradient.cpp
  libqnanopainter/qnanoimagepattern.cpp
  libqnanopainter/qnanoimage.cpp
  libqnanopainter/qnanofont.cpp
  libqnanopainter/qnanoradialgradient.cpp
  libqnanopainter/qnanoboxgradient.cpp
  libqnanopainter/qnanowindow.cpp
  libqnanopainter/private/qnanodebug.cpp
  libqnanopainter/nanovg/nanovg.c
  )

set(${this_target}_headers
  libqnanopainter/private/qnanobrush.h
  libqnanopainter/qnanopainter.h
  libqnanopainter/qnanocolor.h
  libqnanopainter/qnanolineargradient.h
  libqnanopainter/qnanoimagepattern.h
  libqnanopainter/qnanoimage.h
  libqnanopainter/qnanofont.h
  libqnanopainter/qnanoradialgradient.h
  libqnanopainter/qnanoboxgradient.h
  libqnanopainter/private/qnanodataelement.h
  libqnanopainter/private/qnanobackend.h
  libqnanopainter/private/qnanobackendfactory.h
  libqnanopainter/qnanowindow.h
  libqnanopainter/private/qnanodebug.h
  libqnanopainter/nanovg/nanovg.h
  )

set(${this_target}_resources
  libqnanopainter/libqnanopainterdata.qrc
  )

if(${QNANO_BUILD_GLES_BACKENDS})
  message(STATUS "QNanoPainter: Including OpenGL ES backends")
  add_definitions(-DQNANO_BUILD_GLES_BACKENDS)

  set(${this_target}_sources
    ${${this_target}_sources}
    libqnanopainter/private/qnanobackendgles2.cpp
    libqnanopainter/private/qnanobackendgles3.cpp
    )
  set(${this_target}_headers
    ${${this_target}_headers}
    libqnanopainter/private/qnanobackendgles2.h
    libqnanopainter/private/qnanobackendgles3.h
    )
endif()

if(${QNANO_BUILD_GL_BACKENDS})
  message(STATUS "QNanoPainter: Including OpenGL backends")

  find_package(OpenGL REQUIRED)

  add_definitions(-DQNANO_BUILD_GL_BACKENDS)

  set(${this_target}_sources
    ${${this_target}_sources}
    libqnanopainter/private/qnanobackendgl2.cpp
    libqnanopainter/private/qnanobackendgl3.cpp
    )
  set(${this_target}_headers
    ${${this_target}_headers}
    libqnanopainter/private/qnanobackendgl2.h
    libqnanopainter/private/qnanobackendgl3.h
    )

  set(${this_target}_libs
    ${${this_target}_libs}
    PUBLIC OpenGL::GL
    )
endif()

find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Quick)
if(Qt${QT_VERSION_MAJOR}Quick_FOUND)
  message(STATUS "QNanoPainter: Found Qt${QT_VERSION_MAJOR}Quick, will build QtQuick components.")

  set(${this_target}_sources
    ${${this_target}_sources}
    libqnanopainter/qnanoquickitem.cpp
    libqnanopainter/qnanoquickitempainter.cpp
    )
  set(${this_target}_headers
    ${${this_target}_headers}
    libqnanopainter/qnanoquickitem.h
    libqnanopainter/qnanoquickitempainter.h
    )
  set(${this_target}_libs
    ${${this_target}_libs}
    PUBLIC Qt${QT_VERSION_MAJOR}::Quick
    )
endif()

find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Widgets)
if(Qt${QT_VERSION_MAJOR}Widgets_FOUND)
  message(STATUS "QNanoPainter: Found Qt${QT_VERSION_MAJOR}Widgets, will build QtWidget components.")

  set(${this_target}_sources
    ${${this_target}_sources}
    libqnanopainter/qnanowidget.cpp
    )
  set(${this_target}_headers
    ${${this_target}_headers}
    libqnanopainter/qnanowidget.h
    )
  set(${this_target}_libs
    ${${this_target}_libs}
    PUBLIC Qt${QT_VERSION_MAJOR}::Widgets
    )
endif()

add_library(
  ${this_target} STATIC
  ${${this_target}_headers}
  ${${this_target}_sources}
  ${${this_target}_resources}
)

target_include_directories(
  ${this_target}
  PRIVATE libqnanopainter/private
  PUBLIC libqnanopainter
  INTERFACE $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

target_link_libraries(
  ${this_target}
  PUBLIC Qt${QT_VERSION_MAJOR}::Core
  PUBLIC Qt${QT_VERSION_MAJOR}::Gui
  ${${this_target}_libs}
)
