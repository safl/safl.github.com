"""Console-script entry points for the safl.dk docs tooling."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


def _docs_root() -> Path:
    """Locate the docs root: the directory containing ``src/conf.py``.

    The commands are expected to run from inside ``safl.github.com/docs``
    (the directory holding this ``tooling/`` package and the ``src/``
    Sphinx tree). Falls back to the parent in case the user invoked from
    ``docs/tooling``.
    """
    cwd = Path.cwd()
    for candidate in (cwd, cwd.parent):
        if (candidate / "src" / "conf.py").exists():
            return candidate
    sys.exit(
        "safldk-docs: could not find src/conf.py; "
        "run from the docs directory (e.g. safl.github.com/docs)"
    )


def build_html() -> None:
    root = _docs_root()
    src = root / "src"
    out = root / "_build" / "html"
    subprocess.run(
        [sys.executable, "-m", "sphinx", "-W", "-b", "html", str(src), str(out)],
        check=True,
    )


def serve() -> None:
    root = _docs_root()
    src = root / "src"
    out = root / "_build" / "html"
    subprocess.run(
        [
            sys.executable,
            "-m",
            "sphinx_autobuild",
            "--port",
            "8000",
            str(src),
            str(out),
        ],
        check=True,
    )
