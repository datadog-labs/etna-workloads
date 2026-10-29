Creates an fts4 table with languageid and inserts rows with language ids 0 and 1<<30, then reads `t5_segdir.level`.
Clean: levels are 0 and 1<<40 (64-bit absolute level). Buggy: `getAbsoluteLevel` overflows in int arithmetic and
the level is bound as 32-bit, so the second level is 0, and the query output differs (extra `0` row).
