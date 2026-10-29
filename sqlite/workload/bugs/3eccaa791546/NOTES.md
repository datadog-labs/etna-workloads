# Reproducer notes

`repro.sql` runs the `zipfile(X'504b050600000000010001004000000000a3e1110000')`
table-valued function on a 23-byte blob that is just large enough to contain
a well-formed End-Of-Central-Directory record claiming one entry, but too
short to actually hold that entry's 46-byte Central Directory Structure
(this is the same blob added by upstream's own regression test,
zipfile-20.0).

`zipfileGetEntry()` reads the CDS directly out of the in-memory blob
(`aBlob`) at offset `iOff`, with no bounds check before building `aRead =
&aBlob[iOff]` and reading `ZIPFILE_CDS_FIXED_SZ` (46) bytes starting there.
Since `iOff` is close to the end of the 23-byte blob, this reads tens of
bytes past the end of the allocation.

- `bin/sqlite3-clean` (with the fix) checks `(iOff+ZIPFILE_CDS_FIXED_SZ) >
  nBlob` first and returns `SQLITE_CORRUPT`, so the statement fails
  cleanly with `Error near line 1: zip archive is corrupt` (exit status 1).
- `bin/sqlite3-buggy` (bug re-injected) has no such check, overreads the
  heap buffer, and segfaults (exit status -11 / 139) under this debug
  build's allocator/ASan-like layout — nondeterministic in general, but
  reliable here with this exact input and build.
