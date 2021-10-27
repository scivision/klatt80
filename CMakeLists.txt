cmake_minimum_required(VERSION 3.15...3.22)

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

foreach(p AA AH OY)

  add_test(NAME Generate:${p}
  COMMAND $<TARGET_FILE:klatt> ${PROJECT_SOURCE_DIR}/docs-en/${p}.DOC ${PROJECT_BINARY_DIR}/${p}.raw)

  set_tests_properties(Generate:${p} PROPERTIES
  TIMEOUT 5
  )

endforeach()
