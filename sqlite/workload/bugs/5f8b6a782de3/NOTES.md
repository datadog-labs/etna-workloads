repro.sql calls fts3 snippet() with a column index that doesn't fit in 32 bits (4294967299 and -4294967293).
Clean: the first returns '' (column out of range) and the second returns the snippet from any column.
Buggy: the index is truncated to int, so 4294967299 becomes column 3 and -4294967293 becomes 3. Both return 'z' from column d.
