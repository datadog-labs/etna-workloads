`repro.sql` builds an FTS4 table with `languageid=l` and two documents in each of languages 1 and 2. It runs `optimize`, then counts the rows in `t2_segdir`.

The buggy shell's `optimize` only merges language 0, so the language 1 and 2 segments stay unmerged. `count(*)` from `t2_segdir` is 4 on the buggy shell and 2 on the clean one. This matches fts4langid-2.2, which expects the segdir count to drop after `optimize`.

The MATCH queries return the same rows on both shells. Only the segdir count differs.
