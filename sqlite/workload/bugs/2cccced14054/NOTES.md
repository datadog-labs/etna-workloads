Reproducer (repro.sql): in a contentless_delete=1 fts5 table, insert a row and delete it in the same transaction, then query for its token.

Clean shell: the final SELECT returns nothing.
Buggy shell: it returns `3`. The deleted row is still found, because the delete path begins the index write at the wrong point.
