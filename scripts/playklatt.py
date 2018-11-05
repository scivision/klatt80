#!/usr/bin/env python
import numpy as np
import sounddevice
import time

FS = 10000


def playklatt(fn):
    dat = np.fromfile(fn, np.int16)

    dat *= 32768 // dat.max()
    sounddevice.play(dat, FS)

    time.sleep(1.)


if __name__ == '__main__':
    playklatt('wave.raw')
