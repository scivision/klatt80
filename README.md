# klatt80 Klatt Cascade-Parallel Formant Synthesizer

![Actions Status](https://github.com/scivision/klatt80/workflows/ci/badge.svg)


Klatt Cascade-Parallel Formant Synthesizer

This software is a speech synthesizer designed by Dennis Klatt in 1980.

The original routines are programmed for DEC PDP-11 FORTRAN, and code was updated for generic modern Fortran compilers.

Assuming you have a Fortran compiler and CMake, build:

```sh
cmake -B build
cmake --build build
ctest --test-dir build
```

Usage:

```sh
python runklatt.py AA
```

where `AA` is the phoneme under the `-d` directory.

```sh
./klatt paramfile rawfile
```

allows specifying a parameter file at the command line.

The output is a signed 16-bit integer rawfile at 10 kHz sample rate.
This file is read by an audio analysis program or converted to WAV.
A convenient program to do so is SoX:

* Windows: `winget install ChrisBagwell.SoX`
* macOS: `brew install sox`
* Linux: `apt install sox`

## Notes

* GUI formant [editor](http://www.speech.cs.cmu.edu/comp.speech/Section5/Synth/klatt.kpe80.html)
* Original 1980 [paper](https://asa.scitation.org/doi/10.1121/1.383940)
* Master's [thesis](http://digitool.library.mcgill.ca/thesisfile66001.pdf) from 1980s using Klatt synthesizer for Mandarin
