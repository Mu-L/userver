# AUTOGENERATED, DON'T CHANGE THIS FILE!

if (Hiredis_FOUND)
  return()
endif()

if (TARGET Hiredis)
  set(Hiredis_FOUND ON)
  return()
endif()

if (NOT Hiredis_FIND_VERSION OR Hiredis_FIND_VERSION VERSION_LESS 0.13.3)
    set(Hiredis_FIND_VERSION 0.13.3)
endif()

set(FULL_ERROR_MESSAGE "Could not find `Hiredis` package.\n\tDebian: sudo apt update && sudo apt install libhiredis-dev\n\tMacOS: brew install hiredis")
if (Hiredis_FIND_VERSION)
    set(FULL_ERROR_MESSAGE "${FULL_ERROR_MESSAGE}\nRequired version is at least ${Hiredis_FIND_VERSION}")
endif()


include(FindPackageHandleStandardArgs)

find_library(Hiredis_LIBRARIES_hiredis
  NAMES hiredis
)
list(APPEND Hiredis_LIBRARIES ${Hiredis_LIBRARIES_hiredis})

find_path(Hiredis_INCLUDE_DIRS_hiredis_hiredis_h
  NAMES hiredis/hiredis.h
)
list(APPEND Hiredis_INCLUDE_DIRS ${Hiredis_INCLUDE_DIRS_hiredis_hiredis_h})



if (Hiredis_FIND_VERSION)
if (UNIX AND NOT APPLE)
  find_program(DPKG_QUERY_BIN dpkg-query)
  if (DPKG_QUERY_BIN)
    execute_process(
      COMMAND dpkg-query --showformat=\${Version} --show libhiredis-dev
      OUTPUT_VARIABLE Hiredis_version_output
      ERROR_VARIABLE Hiredis_version_error
      RESULT_VARIABLE Hiredis_version_result
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if (Hiredis_version_result EQUAL 0)
      set(Hiredis_VERSION ${Hiredis_version_output})
      message(STATUS "Installed version libhiredis-dev: ${Hiredis_VERSION}")
    endif(Hiredis_version_result EQUAL 0)
  endif(DPKG_QUERY_BIN)
endif(UNIX AND NOT APPLE)
 
if (APPLE)
  find_program(BREW_BIN brew)
  if (BREW_BIN)
    execute_process(
      COMMAND brew list --versions hiredis
      OUTPUT_VARIABLE Hiredis_version_output
      ERROR_VARIABLE Hiredis_version_error
      RESULT_VARIABLE Hiredis_version_result
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if (Hiredis_version_result EQUAL 0)
      if (Hiredis_version_output MATCHES "^(.*) (.*)$")
        set(Hiredis_VERSION ${CMAKE_MATCH_2})
        message(STATUS "Installed version hiredis: ${Hiredis_VERSION}")
      else()
        set(Hiredis_VERSION "NOT_FOUND")
      endif()
    else()
      message(WARNING "Failed execute brew: ${Hiredis_version_error}")
    endif()
  endif()
endif()
 
endif (Hiredis_FIND_VERSION)

 
find_package_handle_standard_args(
  Hiredis
    REQUIRED_VARS
      Hiredis_LIBRARIES
      Hiredis_INCLUDE_DIRS
      
    FAIL_MESSAGE
      "${FULL_ERROR_MESSAGE}"
)
mark_as_advanced(
  Hiredis_LIBRARIES
  Hiredis_INCLUDE_DIRS
  
)


if (Hiredis_FIND_VERSION)
  if (Hiredis_VERSION VERSION_LESS Hiredis_FIND_VERSION)
      message(STATUS
          "Version of Hiredis is ${Hiredis_VERSION}. "
          "Required version is ${Hiredis_FIND_VERSION}. Ignoring found Hiredis."
      )
      set(Hiredis_FOUND OFF)
  endif()
endif()

if (NOT Hiredis_FOUND)
  if (Hiredis_FIND_REQUIRED)
      message(FATAL_ERROR "${FULL_ERROR_MESSAGE}")
  endif()

  return()
endif()

 
if (NOT TARGET Hiredis)
  add_library(Hiredis INTERFACE IMPORTED GLOBAL)

  target_include_directories(Hiredis INTERFACE ${Hiredis_INCLUDE_DIRS})
  target_link_libraries(Hiredis INTERFACE ${Hiredis_LIBRARIES})
  
  # Target Hiredis is created
endif()
