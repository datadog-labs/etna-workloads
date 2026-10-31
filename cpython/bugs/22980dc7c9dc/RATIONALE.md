# Rationale

Fix hunk reversed: in `Lib/zipfile/_path/__init__.py`, the `_base()` helper and
`name`/`suffix`/`suffixes`/`stem` (zipp 3.16.2 made them use
`PurePosixPath(self.at or self.root.filename)`).

v3.15.2 has a later variant (`PurePosixPath(self.at) if self.at else self.filename`)
that already handles the no-filename case when `at` is set. I removed `_base()` and
restored the pre-fix properties: `pathlib.Path(self.at).<attr> or self.filename.<attr>`.
When `at` has no suffix (e.g. `example`), this falls through to `self.filename`,
which calls `pathlib.Path(self.root.filename)`. With `filename = None` that raises TypeError.

Failing oracle case: `TestPath.test_suffix_no_filename` (TypeError from `.suffix`).

Not reverted: the glob and `match` hunks. v3.15.2 has since rewritten glob around
`Translator`, so they can't be reversed cleanly.
