# AUTOGENERATED, DON'T CHANGE THIS FILE!

if (LibEv_FOUND)
  return()
endif()

if (TARGET LibEv)
  set(LibEv_FOUND ON)
  return()
endif()


set(FULL_ERROR_MESSAGE "Could not find `LibEv` package.\n\tDebian: sudo apt update && sudo apt install libev-dev\n\tMacOS: brew install libev")
if (LibEv_FIND_VERSION)
    set(FULL_ERROR_MESSAGE "${FULL_ERROR_MESSAGE}\nRequired version is at least ${LibEv_FIND_VERSION}")
endif()


include(FindPackageHandleStandardArgs)

find_library(LibEv_LIBRARIES_ev
  NAMES ev
)
list(APPEND LibEv_LIBRARIES ${LibEv_LIBRARIES_ev})

find_path(LibEv_INCLUDE_DIRS_ev_h
  NAMES ev.h
)
list(APPEND LibEv_INCLUDE_DIRS ${LibEv_INCLUDE_DIRS_ev_h})



if (LibEv_FIND_VERSION)
if (UNIX AND NOT APPLE)
  find_program(DPKG_QUERY_BIN dpkg-query)
  if (DPKG_QUERY_BIN)
    execute_process(
      COMMAND dpkg-query --showformat=\${Version} --show libev-dev
      OUTPUT_VARIABLE LibEv_version_output
      ERROR_VARIABLE LibEv_version_error
      RESULT_VARIABLE LibEv_version_result
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if (LibEv_version_result EQUAL 0)
      set(LibEv_VERSION ${LibEv_version_output})
      message(STATUS "Installed version libev-dev: ${LibEv_VERSION}")
    endif(LibEv_version_result EQUAL 0)
  endif(DPKG_QUERY_BIN)
endif(UNIX AND NOT APPLE)
 
if (APPLE)
  find_program(BREW_BIN brew)
  if (BREW_BIN)
    execute_process(
      COMMAND brew list --versions libev
      OUTPUT_VARIABLE LibEv_version_output
      ERROR_VARIABLE LibEv_version_error
      RESULT_VARIABLE LibEv_version_result
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if (LibEv_version_result EQUAL 0)
      if (LibEv_version_output MATCHES "^(.*) (.*)$")
        set(LibEv_VERSION ${CMAKE_MATCH_2})
        message(STATUS "Installed version libev: ${LibEv_VERSION}")
      else()
        set(LibEv_VERSION "NOT_FOUND")
      endif()
    else()
      message(WARNING "Failed execute brew: ${LibEv_version_error}")
    endif()
  endif()
endif()
 
endif (LibEv_FIND_VERSION)

 
find_package_handle_standard_args(
  LibEv
    REQUIRED_VARS
      LibEv_LIBRARIES
      LibEv_INCLUDE_DIRS
      
    FAIL_MESSAGE
      "${FULL_ERROR_MESSAGE}"
)
mark_as_advanced(
  LibEv_LIBRARIES
  LibEv_INCLUDE_DIRS
  
)


if (LibEv_FIND_VERSION)
  if (LibEv_VERSION VERSION_LESS LibEv_FIND_VERSION)
      message(STATUS
          "Version of LibEv is ${LibEv_VERSION}. "
          "Required version is ${LibEv_FIND_VERSION}. Ignoring found LibEv."
      )
      set(LibEv_FOUND OFF)
  endif()
endif()

if (NOT LibEv_FOUND)
  if (LibEv_FIND_REQUIRED)
      message(FATAL_ERROR "${FULL_ERROR_MESSAGE}")
  endif()

  return()
endif()

 
if (NOT TARGET LibEv)
  add_library(LibEv INTERFACE IMPORTED GLOBAL)

  target_include_directories(LibEv INTERFACE ${LibEv_INCLUDE_DIRS})
  target_link_libraries(LibEv INTERFACE ${LibEv_LIBRARIES})
  
  # Target LibEv is created
endif()
