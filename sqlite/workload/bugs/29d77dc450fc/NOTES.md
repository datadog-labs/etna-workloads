# Notes

`repro.sql` recreates upstream test `fts3corrupt4.test` case 1.3: create an
FTS3 table, insert three rows so a segment b-tree interior node exists, then
corrupt the `root` blob of `ft_segdir` so that a node-size varint decodes to
a huge value (`0xFFFFFFFF07`), and run a MATCH query that walks that node.

`.dbconfig defensive off` is needed because the harness disables the
DEFENSIVE flag before poking at the shadow tables directly (`sqlite3_db_config
db DEFENSIVE 0` in `fts3_common.tcl`); without it the UPDATE on `ft_segdir`
is rejected.

- Clean shell (fix applied): the corrupt node size is caught by the bounds
  check in `fts3ScanInteriorNode()`/`nodeReaderNext()`, and the query fails
  cleanly with `SQLITE_CORRUPT` ("database disk image is malformed"), exit
  status 1.
- Buggy shell (`injection.patch`): the bounds checks are weakened/removed and
  the allocation-size variable is narrowed back to `int`, so the oversized
  suffix length overflows `nAlloc`/causes an out-of-bounds read while
  scanning the interior node, crashing the process (SIGSEGV, exit status
  -11) instead of reporting corruption.
