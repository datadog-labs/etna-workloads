repro.sql creates a table with a column declared `COLLATE binary`, indexes it, and runs VACUUM.
The buggy shell hits the re-added assert() in xferOptimization (the index's collation name is not the
sqlite3StrBINARY pointer) and aborts. The clean shell finishes with no output.
