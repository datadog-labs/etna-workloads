# Rationale

Hunk reversed: `Lib/tarfile.py` `TarFile.addfile` — the fix added
`if fileobj is None and tarinfo.isreg() and tarinfo.size != 0: raise ValueError(...)`.
v3.15.2 still had this check verbatim (only the docstring was reflowed), so
I removed those two lines. With the check gone, `addfile(tarinfo)` for a
non-empty regular file writes a header with no data (an incomplete entry).

Oracle: `test_missing_fileobj` fails in each WriteTest variant (plain, gz,
bz2, xz; 4 failures) with `AssertionError: ValueError not raised`.
