# C++ standard
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
if (NOT CMAKE_CXX_STANDARD OR CMAKE_CXX_STANDARD LESS 11)
  set(CMAKE_CXX_STANDARD 11)
endif ()

include (CheckCXXCompilerFlag)

check_cxx_compiler_flag ("-Wall" Wall_FLAG_SUPPORTED)
if (Wall_FLAG_SUPPORTED)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
endif (Wall_FLAG_SUPPORTED)

check_cxx_compiler_flag ("-pedantic" pedantic_FLAG_SUPPORTED)
if (pedantic_FLAG_SUPPORTED)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pedantic")
endif (pedantic_FLAG_SUPPORTED)

check_cxx_compiler_flag ("-Wextra" Wextra_FLAG_SUPPORTED)
if (Wextra_FLAG_SUPPORTED)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wextra")
endif (Wextra_FLAG_SUPPORTED)

if (CMAKE_CXX_COMPILER_ID MATCHES GNU)
  # Warnings
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")

  # Optimizations
  if (CMAKE_BUILD_TYPE MATCHES Release)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")
  elseif (CMAKE_BUILD_TYPE MATCHES Debug)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0")
  endif ()
endif ()
