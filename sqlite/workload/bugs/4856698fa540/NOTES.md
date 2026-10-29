ANALYZE must compare index columns using the column's collating sequence. The reproducer
makes nocase and rtrim indexes with rows that are equal only under those collations, then
reads sqlite_stat1. Clean gives the collation-aware counts; buggy compares with binary
collation, so the second stat number (rows per distinct key) is wrong.
