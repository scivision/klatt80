#!/bin/sh
sox -t raw -c 1 -r 10k -b 16 -e signed-integer --endian little wave.raw -t wav wave.wav
