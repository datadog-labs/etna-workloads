Builds a zip in memory, sets `filename = None`, and reads suffix/suffixes/name/stem of `zipfile.Path(zf).joinpath("example")`.
Clean: `''`, `[]`, `'example'`, `'example'`. Buggy: suffix/suffixes (empty at-suffix) fall back to the None filename and raise TypeError.
