#!/usr/bin/env python
import subprocess
import argparse
import shutil
from pathlib import Path

try:
    from matplotlib.pyplot import show
except ImportError:
    show = None

from klatt.playklatt import playklatt
from klatt.plotklatt import plotklatt

rawfn = "wave.raw"

R = Path(__file__).resolve().parent
EXE = shutil.which("klatt", path=str(R / "build"))


def runklatt(phoneme: str, path: Path):
    path = Path(path).expanduser()

    paramfn = path / (phoneme + ".DOC")
    if not paramfn.is_file():
        raise SystemExit(f"{paramfn} not found")

    subprocess.check_call([EXE, str(paramfn)])

    playklatt(rawfn)

    if show is not None:
        plotklatt(rawfn)


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("phoneme", help=".doc file")
    p.add_argument("-d", "--path", help="phoneme directory", default=R / "docs-en")
    P = p.parse_args()

    runklatt(P.phoneme, P.path)
    if show is not None:
        show()
