# AUTOGENERATED, DON'T CHANGE THIS FILE!

if (GssApi_FOUND)
  return()
endif()

if (TARGET GssApi)
  set(GssApi_FOUND ON)
  return()
endif()


set(FULL_ERROR_MESSAGE "Could not find `GssApi` package.\n\tDebian: sudo apt update && sudo apt install libkrb5-dev\n\tMacOS: brew install krb5")
if (GssApi_FIND_VERSION)
    set(FULL_ERROR_MESSAGE "${FULL_ERROR_MESSAGE}\nRequired version is at least ${GssApi_FIND_VERSION}")
endif()


include(FindPackageHandleStandardArgs)

find_library(GssApi_LIBRARIES_gssapi_krb5_gssapi
  NAMES gssapi_krb5 gssapi
)
list(APPEND GssApi_LIBRARIES ${GssApi_LIBRARIES_gssapi_krb5_gssapi})

find_path(GssApi_INCLUDE_DIRS_gssapi_h
  NAMES gssapi.h
  PATH_SUFFIXES gssapi
)
list(APPEND GssApi_INCLUDE_DIRS ${GssApi_INCLUDE_DIRS_gssapi_h})



if (GssApi_FIND_VERSION)
if (UNIX AND NOT APPLE)
  find_program(DPKG_QUERY_BIN dpkg-query)
  if (DPKG_QUERY_BIN)
    execute_process(
      COMMAND dpkg-query --showformat=\${Version} --show libkrb5-dev
      OUTPUT_VARIABLE GssApi_version_output
      ERROR_VARIABLE GssApi_version_error
      RESULT_VARIABLE GssApi_version_result
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if (GssApi_version_result EQUAL 0)
      set(GssApi_VERSION ${GssApi_version_output})
      message(STATUS "Installed version libkrb5-dev: ${GssApi_VERSION}")
    endif(GssApi_version_result EQUAL 0)
  endif(DPKG_QUERY_BIN)
endif(UNIX AND NOT APPLE)
 
if (APPLE)
  find_program(BREW_BIN brew)
  if (BREW_BIN)
    execute_process(
      COMMAND brew list --versions krb5
      OUTPUT_VARIABLE GssApi_version_output
      ERROR_VARIABLE GssApi_version_error
      RESULT_VARIABLE GssApi_version_result
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if (GssApi_version_result EQUAL 0)
      if (GssApi_version_output MATCHES "^(.*) (.*)$")
        set(GssApi_VERSION ${CMAKE_MATCH_2})
        message(STATUS "Installed version krb5: ${GssApi_VERSION}")
      else()
        set(GssApi_VERSION "NOT_FOUND")
      endif()
    else()
      message(WARNING "Failed execute brew: ${GssApi_version_error}")
    endif()
  endif()
endif()
 
endif (GssApi_FIND_VERSION)

 
find_package_handle_standard_args(
  GssApi
    REQUIRED_VARS
      GssApi_LIBRARIES
      GssApi_INCLUDE_DIRS
      
    FAIL_MESSAGE
      "${FULL_ERROR_MESSAGE}"
)
mark_as_advanced(
  GssApi_LIBRARIES
  GssApi_INCLUDE_DIRS
  
)


if (GssApi_FIND_VERSION)
  if (GssApi_VERSION VERSION_LESS GssApi_FIND_VERSION)
      message(STATUS
          "Version of GssApi is ${GssApi_VERSION}. "
          "Required version is ${GssApi_FIND_VERSION}. Ignoring found GssApi."
      )
      set(GssApi_FOUND OFF)
  endif()
endif()

if (NOT GssApi_FOUND)
  if (GssApi_FIND_REQUIRED)
      message(FATAL_ERROR "${FULL_ERROR_MESSAGE}")
  endif()

  return()
endif()

 
if (NOT TARGET GssApi)
  add_library(GssApi INTERFACE IMPORTED GLOBAL)

  target_include_directories(GssApi INTERFACE ${GssApi_INCLUDE_DIRS})
  target_link_libraries(GssApi INTERFACE ${GssApi_LIBRARIES})
  
  # Target GssApi is created
endif()
