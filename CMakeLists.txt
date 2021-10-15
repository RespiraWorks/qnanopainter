cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)
project(qnanopainter
  LANGUAGES CXX C
  VERSION 0.0.1
  )

set(this_target QNanoPainter)

option(QNANO_QUICK "Build QNanoPainter for QtQuick" OFF)

option(QNANO_WIDGETS "Build QNanoPainter for QtWidgets" OFF)

find_package(Qt5 COMPONENTS Core Gui REQUIRED)

# Enable this to get drawing debug information
#add_definitions(-DQNANO_DEBUG)

# Enable this to let Qt include OpenGL headers
add_definitions(-DQNANO_QT_GL_INCLUDE)

# This will enable GLES3 (disable to force GLES2)
add_definitions(-DQNANO_ENABLE_GLES3)

# This will enable signalling touch events
# Can be useful when using view/widget classes directly
#add_definitions(-DQNANO_ENABLE_TOUCH_SIGNALS)

# This will enable signalling paint events
# Can be useful when using view/widget classes directly
#add_definitions(-DQNANO_ENABLE_PAINT_SIGNALS)

# When building for embedded devices you can define manually which backends are supported
set(QNANO_BUILD_GLES_BACKENDS OFF)
set(QNANO_BUILD_GL_BACKENDS ON)

# \TODO: autodetect backends

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

qt5_add_resources(${this_target}_resources
  libqnanopainter/libqnanopainterdata.qrc)

if(QNANO_BUILD_GLES_BACKENDS)
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

if(QNANO_BUILD_GL_BACKENDS)
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

if (QNANO_QUICK)
  message(STATUS "QNanoPainter: Including QtQuick components")
  find_package(Qt5 COMPONENTS Quick REQUIRED)

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
    PUBLIC Qt5::Quick
    )
endif()

if (QNANO_WIDGETS)
  message(STATUS "QNanoPainter: Including QtWidget components")
  find_package(Qt5 COMPONENTS Widgets REQUIRED)

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
    PUBLIC Qt5::Widgets
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
  PUBLIC Qt5::Core
  PUBLIC Qt5::Gui
  ${${this_target}_libs}
)
