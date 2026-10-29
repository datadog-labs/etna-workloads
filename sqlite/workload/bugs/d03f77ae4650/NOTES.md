Reproducer (repro.sql): the Tcl vtab from bestindex7.test is test-only, so this uses FTS4
instead. FTS4's hidden languageid column gets an EQ constraint that it uses in xBestIndex
without setting `omit`, and its full-scan path ignores it. With an external-content table
whose language-id column holds NULL, `lid IN (0,1)` makes SQLite re-check each IN term
itself.

Clean: that re-check uses SQLITE_JUMPIFNULL, so the NULL-lid row is dropped. Output: `x|0`.
Buggy: the re-check has no JUMPIFNULL, so the NULL row passes. Output: `x|0`, `y|`, `y|`.
The row appears twice because of the two IN values.
