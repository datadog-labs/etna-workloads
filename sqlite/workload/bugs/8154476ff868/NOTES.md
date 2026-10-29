Reproducer (repro.sql) is fts5corruptA-3.1: builds an fts5 table, overwrites the leaf
page in t1_data with 0xFF bytes (corrupt poslist), then runs a column-filtered query
`MATCH '{a b}: hello'`.

Clean shell: exits 0 and returns the row. Buggy shell: the unbounded varint skip loop in
fts5IndexExtractColset overreads, hitting an assert in fts5IndexExtractColset
(abort, exit status -6).
