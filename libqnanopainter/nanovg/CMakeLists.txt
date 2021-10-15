set(dir ${CMAKE_CURRENT_SOURCE_DIR})

set(SOURCES
  ${dir}/nanovg.c
  )

set(HEADERS
  ${dir}/nanovg.h
  )

#install(FILES ${HEADERS}
#  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${this_target}/nanovg)

set(${this_target}_headers ${${this_target}_headers} ${HEADERS} PARENT_SCOPE)
set(${this_target}_sources ${${this_target}_sources} ${SOURCES} PARENT_SCOPE)
