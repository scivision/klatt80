#!/usr/bin/env python
import numpy as np
from matplotlib.pyplot import figure, show
import sys

FS = 10000


def plotklatt(fn):
    dat = np.fromfile(fn, np.int16)

    t = np.arange(0, dat.size / FS, 1 / FS)
    ax = figure().gca()
    ax.plot(t, dat)
    ax.set_xlabel("time [sec]")
    ax.set_ylabel("amplitude [16-bit]")


if __name__ == "__main__":
    plotklatt(sys.argv[1])
    show()
