set(this_target qnanopainter)

set(${this_target}_sources
  qnanopainter.cpp
  qnanocolor.cpp
  qnanolineargradient.cpp
  qnanoimagepattern.cpp
  qnanoimage.cpp
  qnanofont.cpp
  qnanoradialgradient.cpp
  qnanoboxgradient.cpp
  qnanowindow.cpp
  )

set(${this_target}_headers
  qnanopainter.h
  qnanocolor.h
  qnanolineargradient.h
  qnanoimagepattern.h
  qnanoimage.h
  qnanofont.h
  qnanoradialgradient.h
  qnanoboxgradient.h
  qnanowindow.h
  )

set(${this_target}_resources
  libqnanopainterdata.qrc
  )

if(${QNANO_BUILD_GLES_BACKENDS})
  message(STATUS "QNanoPainter: Including OpenGL ES backends")
  add_definitions(-DQNANO_BUILD_GLES_BACKENDS)
endif()

if(${QNANO_BUILD_GL_BACKENDS})
  message(STATUS "QNanoPainter: Including OpenGL backends")
  add_definitions(-DQNANO_BUILD_GL_BACKENDS)
  find_package(OpenGL REQUIRED)
  set(${this_target}_libs
    ${${this_target}_libs}
    PUBLIC OpenGL::GL
    )
endif()

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/nanovg)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/private)

find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Quick)
if(Qt${QT_VERSION_MAJOR}Quick_FOUND)
  message(STATUS "QNanoPainter: Found Qt${QT_VERSION_MAJOR}Quick, will build QtQuick components.")

  set(${this_target}_sources
    ${${this_target}_sources}
    qnanoquickitem.cpp
    qnanoquickitempainter.cpp
    )
  set(${this_target}_headers
    ${${this_target}_headers}
    qnanoquickitem.h
    qnanoquickitempainter.h
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
    qnanowidget.cpp
    )
  set(${this_target}_headers
    ${${this_target}_headers}
    qnanowidget.h
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
  PRIVATE private
  PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}
  INTERFACE $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

target_link_libraries(
  ${this_target}
  PUBLIC Qt${QT_VERSION_MAJOR}::Core
  PUBLIC Qt${QT_VERSION_MAJOR}::Gui
  ${${this_target}_libs}
)
