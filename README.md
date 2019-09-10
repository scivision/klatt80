[![Actions Status](https://github.com/scivision/klatt80/workflows/ci/badge.svg)](https://github.com/scivision/klatt80/actions)

# klatt80

Klatt Cascade-Parallel Formant Synthesizer

This software is a speech synthesizer designed by Dennis Klatt in 1980.

The original routines are programmed for DEC PDP-11 FORTRAN, and code was updated for generic modern Fortran compilers.
Due to old / unstable progamming techniques, compiler optimization option `-O1` is typically necessary.


## Build

Assuming you have a Fortran compiler and CMake, do:

```sh
meson build
meson test -C build
```

## Raw to WAV

An example is given under `scripts/` of converted `int16` RAW to WAV.
This is not necessary if loading into Python/Matlab.
Sample rate is 10 kHz.

## Usage

```sh
./klatt  paramfile
```

allows specifying a parameter file at the command line.
Otherwise,

```sh
./klatt
```
requests parameters.

in any case, a file `wave.raw` is written, a signed 16-bit integer file at 10 kHz.
This file is easily read by any analysis program, or converted to WAV.
Some Matlab / GNU Octave scripts are given under `scripts/` and are self-explanatory.



## Notes

* GUI formant [editor](http://www.speech.cs.cmu.edu/comp.speech/Section5/Synth/klatt.kpe80.html)
* Original 1980 [paper](https://asa.scitation.org/doi/10.1121/1.383940)
* Master's [thesis](http://digitool.library.mcgill.ca/thesisfile66001.pdf) from 1980s using Klatt synthesizer for Mandarin
