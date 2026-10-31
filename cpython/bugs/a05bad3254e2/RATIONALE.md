# Rationale

Fix gh-100370 made `sqlite3.Connection.blobopen` take the row id as `sqlite3_int64` (via a new
`sqlite3_int64_converter`) instead of `int`. Reversed in v3.15.2:

- `Modules/_sqlite/connection.c`: removed the `sqlite3_int64_converter()` function and the matching
  Argument Clinic converter class (hunks 2 and 3 of the fix); changed the clinic input
  `rowid as row: sqlite3_int64` back to `int` and `blobopen_impl`'s `row` parameter to `int`.
  (v3.15.2 spells the parameter `rowid as row`, so only the type changed.)
- `Modules/_sqlite/clinic/connection.c.h`: regenerated with clinic, so `row` is `int` again and is
  parsed with `PyLong_AsInt` (the modern `_PyLong_AsInt`), reversing the first hunk.

Oracle failure: `BlobTests.test_blob_32bit_rowid` errors with
`OverflowError: Python int too large to convert to C int` for rowid 2**32. The other 205 tests pass.
