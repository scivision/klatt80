project('klatt80', 'fortran',
  default_options : ['default_library=static', 'buildtype=release', 'warninglevel=0'])

fc = meson.get_compiler('fortran')
nowarn = fc.first_supported_argument(['-w', '-nowarn', '/nowarn'])
if fc.get_id() == 'gcc'
  # Gfortran doesn't work for -O0
  add_project_arguments('-O1', nowarn, '-std=legacy', '-fimplicit-none', '-fbounds-check', '-Wno-unused-label', '-Wline-truncation', language: 'fortran')
elif fc.get_id() == 'intel'
  # Intel doesn't work for -O0, -O2, -O3
  add_project_arguments('-O1', nowarn, language: 'fortran')
elif fc.get_id() == 'intel-cl'
  add_project_arguments('/O1', nowarn, language: 'fortran')
elif fc.get_id() == 'flang'
  # Flang 6 didn't work right for any -Ox level
  add_project_arguments('-O1', nowarn, language: 'fortran')
elif fc.get_id() == 'pgi'
  # PGI 18.10 didn't work right for any -Ox level
  add_project_arguments('-O1', nowarn, language: 'fortran')
endif

klatt_exe = executable('klatt', 'handsy.for', 'parcoe.for', 'coewav.for', 'setabc.for', 'getamp.for')
