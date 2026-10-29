repro.sql: creates an fts5 table with two columns and runs snippet() on column 0 for 'x', where the other column's last token also matches 'x'.
Clean returns `[x] a a a a a...`; buggy returns `...a a a a a a`, which has no phrase instance. The buggy build computes the snippet end from the last instance iterated, which may be in another column, instead of the last instance in the column.
