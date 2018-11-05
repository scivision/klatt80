#!/usr/bin/env python
import subprocess
import sys
from playklatt import playklatt
from plotklatt import plotklatt
from matplotlib.pyplot import show
import os

rawfn = 'wave.raw'
exe = './klatt'
if os.name == 'nt':
    exe = exe[2:]+'.exe'


def runklatt(phoneme):

    paramfn = 'docs-ja/' + phoneme + '.DOC'

    subprocess.check_call([exe, paramfn])

    playklatt(rawfn)

    plotklatt(rawfn)


if __name__ == '__main__':
    runklatt(sys.argv[1])
    show()
