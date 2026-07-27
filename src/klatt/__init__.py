import numpy as np
import time
from pathlib import Path


FS = 10000


def load_klatt(fn: Path):

    dat = np.fromfile(fn, np.int16)

    dat *= 32768 // dat.max()

    return dat


def raw2wav(dat, wavfn: Path):
    import scipy.io.wavfile

    scipy.io.wavfile.write(wavfn, FS, dat)


def playklatt(dat):
    import sounddevice

    sounddevice.play(dat, FS)

    time.sleep(1.0)


def plotklatt(dat):
    from matplotlib.pyplot import figure

    t = np.arange(0, dat.size / FS, 1 / FS)
    ax = figure().gca()
    ax.plot(t, dat)
    ax.set_xlabel("time [sec]")
    ax.set_ylabel("amplitude [16-bit]")
