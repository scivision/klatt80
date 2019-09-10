#!/usr/bin/env python
import numpy as np
import sounddevice
import time
from pathlib import Path

FS = 10000


def playklatt(fn: Path):
    dat = np.fromfile(fn, np.int16)

    dat *= 32768 // dat.max()
    sounddevice.play(dat, FS)

    time.sleep(1.0)
