Sets `tempfile.tempdir` to bytes, then prints the types returned by `gettempdir()`, `gettempdirb()` and `mkdtemp()`.
Clean: `str`, `bytes`, `bytes`. Buggy: `gettempdir()` returns `bytes` instead of `str`, or an error is raised (bpo-40701).
