#!/usr/bin/env python3
import subprocess
import argparse
import shutil
from pathlib import Path

try:
    from matplotlib.pyplot import show
except ImportError:
    show = None

from klatt import load_klatt, playklatt, plotklatt

R = Path(__file__).resolve().parent
bindir = R / "build"
EXE = shutil.which("klatt", path=bindir)


def runklatt(phoneme: str, path: Path):
    path = Path(path).expanduser()

    paramfn = path / (phoneme + ".DOC")
    if not paramfn.is_file():
        raise SystemExit(f"{paramfn} not found")

    rawfn = bindir / (paramfn.name + ".raw")

    subprocess.check_call([EXE, str(paramfn), str(rawfn)])

    dat = load_klatt(rawfn)
    playklatt(dat)

    if show is not None:
        plotklatt(dat)


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("phoneme", help=".doc file")
    p.add_argument("-d", "--path", help="phoneme directory", default=R / "docs-en")
    P = p.parse_args()

    runklatt(P.phoneme, P.path)
    if show is not None:
        show()
