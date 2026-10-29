Creates an fts4 table with languageid, inserts one row in language 0 and one in language 1<<30.
The fix makes getAbsoluteLevel use 64-bit arithmetic. In the buggy shell the level overflows int:
t6_segdir shows level 0 instead of 1099511627776, so the language-0 query MATCH 'belong'
also returns docid 2 (clean: only 1), and the lid=1<<30 query returns 1 and 2 (clean: only 2).
