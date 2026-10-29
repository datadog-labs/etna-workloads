Reproducer for the fts5vocab xFilter bug (fts5vocab2-7.1). A correlated subquery on an
fts5vocab(col) table re-uses the virtual cursor for each outer row. Without the
fix, fts5VocabResetCursor() does not clear iCol/colUsed/aCnt/aDoc, so the
second use of the cursor omits rows.
Clean shell returns the row "xx" twice; the buggy shell returns it only once.
