Reproducer (`repro.sql`): fts5 table with `detail=none`, three rows inserted in one transaction, then prefix query `t1('b*')`.

The clean shell returns rowids 1, 2, 3. The buggy shell returns 2, 4, because the prefix-query rowid-list merge (`fts5MergeRowidLists`) reads the second list with the wrong iterator.
