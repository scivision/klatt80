cmake_minimum_required(VERSION 3.1)
project(klatt80 Fortran)

list(APPEND FFLAGS -g)

if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  # Gfortran doesn't work for -O0
  list(APPEND FFLAGS -std=legacy -fimplicit-none -fbounds-check -Wno-unused-label -Wline-truncation)
  list(APPEND FFLAGS -O1)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
  # Intel doesn't work for -O0, -O2, -O3
  list(APPEND FFLAGS -O1)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL Flang)
  # Flang 6 didn't work right for any -Ox level
  list(APPEND FFLAGS -O1)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
  # PGI 18.10 didn't work right for any -Ox level
  list(APPEND FFLAGS -O1)
endif()

add_executable(klatt handsy.for parcoe.for coewav.for setabc.for getamp.for)
target_compile_options(klatt PRIVATE ${FFLAGS})