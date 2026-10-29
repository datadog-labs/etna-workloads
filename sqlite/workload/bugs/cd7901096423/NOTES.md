Creates an fts3 table, inserts a value with an embedded 0x00 byte (x'00'), and runs the
fts3 'integrity-check'. The clean shell succeeds and prints "ok"; the buggy shell
tokenizes with the wrong length and reports the table as corrupt (SQLITE_CORRUPT_VTAB error).
