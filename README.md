# safl.dk

Source for https://safl.dk, a personal notebook published to GitHub Pages. It
is built with Sphinx + MyST (Markdown) using the custom `blue8bit` theme.
Content lives under [`docs/src/`](docs/src/) as Markdown; no rendered output is
committed. The site is built and deployed by
[`.github/workflows/docs.yml`](.github/workflows/docs.yml) on every push to
`main`.

## Layout

- `docs/src/` - Markdown sources and `conf.py` (the Sphinx config).
- `docs/src/notebook/` - the notes, one directory per topic.
- `docs/src/_themes/blue8bit/` - the custom theme.
- `docs/tooling/` - the pipx package that provides the build commands.

## Prerequisites

Python 3.11+, [pipx](https://pipx.pypa.io/) (run `pipx ensurepath` once), and
`make`.

## Install the build tooling (once)

```bash
cd docs
make deps
```

This runs `pipx install ./tooling`, providing the `safldk-docs-serve` and
`safldk-docs-build-html` commands.

## Read / preview locally

```bash
cd docs
make serve
```

A live-rebuild dev server starts on http://localhost:8000; saving any file under
`docs/src/` rebuilds and refreshes the browser. This is the way to read the
notebook while working on it.

## Build

```bash
cd docs
make html     # output in docs/_build/html/
make clean    # remove docs/_build/
```

Open `docs/_build/html/index.html` to read a one-shot build.

## Write / update content

Pages are [MyST Markdown](https://myst-parser.readthedocs.io/) files under
`docs/src/`. To add a page:

1. Create the file, e.g. `docs/src/notebook/<topic>/index.md`, or a `.md`
   alongside existing siblings in a topic directory.
2. Add its path (without the `.md` extension) to the nearest `toctree` - the
   topic's own `index.md`, or `docs/src/notebook/index.md` for a new top-level
   topic.
3. Run `make serve` and check it renders.

Conventions used across the notebook:

- Directives use the MyST fenced form:
  ` ```{toctree} `, ` ```{literalinclude} file `, ` ```{image} foo.png `,
  ` ```{figure} foo.png `, ` ```{note} `.
- External links use the `xref-*` roles defined in `docs/src/conf.py`, e.g.
  `` {xref-os-debian}`Debian<>` ``. Add new destinations to the `extlinks` dict
  there rather than hardcoding URLs.
- Pull command transcripts and config files in with ` ```{literalinclude} `
  instead of pasting them inline.
- The build runs with warnings-as-errors (`-W`). A page that is not linked from
  any `toctree` must carry `orphan: true` frontmatter, or the build fails.

## Publish

Push to `main`; the Docs workflow builds and deploys to GitHub Pages. The
repository's Pages source must be set to "GitHub Actions" in Settings.
