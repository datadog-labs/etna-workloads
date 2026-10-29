Creates a table with a BINARY-collated column plus an index on it, then queries
`foldername < 'FolderC' COLLATE nocase`. Correct result is 2 (nocase compare).
The buggy shell ignores the explicit COLLATE when matching the WHERE term to the
index and uses the column's BINARY collation, returning 1.
