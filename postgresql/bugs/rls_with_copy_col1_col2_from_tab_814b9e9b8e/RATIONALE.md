Changed: src/backend/commands/copy.c, DoCopy(), RLS branch ("Build target list").
Traces to the single fix_impl.patch hunk set in DoCopy. The per-column ColumnRef/ResTarget
loop is replaced by the old code: one ColumnRef whose `fields` is the whole attlist, in one
ResTarget. With `COPY t (col1, col2) TO` on an RLS table, the generated SELECT treats
the column list as one qualified name (col1.col2) instead of separate columns, so it fails
or selects the wrong thing.

Failing oracle case: src/test/regress||copy2
