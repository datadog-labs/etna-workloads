repro.sql: an FTS5 table (detail=full) holds a segment with a delete-marker for rowid 2 / term 'bbb'. The query `t9('a*')` (prefix query, no prefix index) should return only rowid 1.
The buggy shell also returns rowid 3 (term 'bbb', which doesn't match 'a*'), because fts5MultiIterNext2 doesn't reset *pbNewTerm across loop iterations.
