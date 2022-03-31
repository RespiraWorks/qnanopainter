set(dir ${CMAKE_CURRENT_SOURCE_DIR})

set(SOURCES
  ${dir}/qnanodebug.cpp
  )

set(HEADERS
  ${dir}/qnanobrush.h
  ${dir}/qnanodataelement.h
  ${dir}/qnanobackend.h
  ${dir}/qnanobackendfactory.h
  ${dir}/qnanodebug.h
  )

if(${QNANO_BUILD_GLES_BACKENDS})
  set(SOURCES
    ${SOURCES}
    ${dir}/qnanobackendgles2.cpp
    ${dir}/qnanobackendgles3.cpp
    )
  set(HEADERS
    ${HEADERS}
    ${dir}/qnanobackendgles2.h
    ${dir}/qnanobackendgles3.h
    )
endif()

if(${QNANO_BUILD_GL_BACKENDS})
  set(SOURCES
    ${SOURCES}
    ${dir}/qnanobackendgl2.cpp
    ${dir}/qnanobackendgl3.cpp
    )
  set(HEADERS
    ${HEADERS}
    ${dir}/qnanobackendgl2.h
    ${dir}/qnanobackendgl3.h
    )
endif()

set(${this_target}_headers ${${this_target}_headers} ${HEADERS} PARENT_SCOPE)
set(${this_target}_sources ${${this_target}_sources} ${SOURCES} PARENT_SCOPE)

