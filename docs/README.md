# safl.dk documentation

Source for the site published at https://safl.dk. Built with Sphinx + MyST,
following the layout used by `safl/nosi` and `safl/bty`. The custom `blue8bit`
Sphinx theme (under `src/_themes/`) is kept.

## Required tools

- Python 3.11+
- pipx (with `pipx ensurepath` run once)
- make

## Build setup

From the `docs` directory, install the tooling package:

```bash
pipx install ./tooling
```

This installs two commands: `safldk-docs-serve` and `safldk-docs-build-html`.

## Development server

Run the live-rebuild dev server:

```bash
safldk-docs-serve
```

This watches `docs/src/` and rebuilds HTML on every change. The server listens
on `http://localhost:8000`.

## One-shot build

```bash
safldk-docs-build-html
```

Output lands under `docs/_build/html/`. The published site is built and deployed by
`.github/workflows/docs.yml` on every push to `main`; nothing is committed under
`_build/`.
