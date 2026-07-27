cmake_minimum_required(VERSION 3.15)

project(klatt80
LANGUAGES Fortran
)

enable_testing()

add_compile_options(
"$<$<Fortran_COMPILER_ID:GNU>:-O1;-std=legacy;-fimplicit-none;-fbounds-check;-Wno-unused-label;-Wline-truncation>"
$<$<Fortran_COMPILER_ID:Intel,IntelLLVM>:-O1>
)
# Gfortran doesn't work for -O0
# Intel doesn't work for -O0, -O2, -O3

add_executable(klatt
handsy.for parcoe.for coewav.for setabc.for getamp.for
)

find_program(ffmpeg NAMES ffmpeg)
if(ffmpeg)
  find_program(ffplay NAMES ffplay)
  message(STATUS "ffmpeg: ${ffmpeg}")
  message(STATUS "ffplay: ${ffplay}")
else()
  find_program(sox NAMES sox)
  message(STATUS "sox: ${sox}")
endif()

foreach(p IN ITEMS AA AH OY)

set(in ${CMAKE_CURRENT_SOURCE_DIR}/docs-en/${p}.DOC)
set(gen ${CMAKE_CURRENT_BINARY_DIR}/${p}.raw)
set(wav ${CMAKE_CURRENT_BINARY_DIR}/${p}.wav)

  add_test(NAME Generate:${p} COMMAND klatt ${in} ${gen})
  set_tests_properties(Generate:${p} PROPERTIES
    FIXTURES_SETUP Generate:${p}
    REQUIRED_FILES ${in})

  if(sox)
    set(convert_cmd ${sox} -t raw -c 1 -r 10k -b 16 -e signed-integer --endian little ${gen} -t wav ${wav})
  elseif(ffmpeg)
    set(convert_cmd ${ffmpeg} -f s16le -ar 10k -ac 1 ${gen} -t wav ${wav})
  else()
    set(convert_cmd)
  endif()

  if(convert_cmd)
    add_test(NAME Convert:${p} COMMAND ${convert_cmd})
    set_tests_properties(Convert:${p} PROPERTIES
      FIXTURES_REQUIRED Generate:${p}
      FIXTURES_SETUP Convert:${p}
      REQUIRED_FILES ${gen}
      )
  endif()

  if(ffplay)
    add_test(NAME Play:${p} COMMAND ${ffplay} -autoexit -nodisp ${wav})
    set_tests_properties(Play:${p} PROPERTIES
      FIXTURES_REQUIRED Convert:${p}
      REQUIRED_FILES ${wav}
    )
  endif()
endforeach()
