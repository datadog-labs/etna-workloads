repro.sql runs the tkt3424 test: a LEFT OUTER JOIN of `names` and `orig`, before and after creating an index on orig(code, data).

Clean shell: 2 rows each time. Buggy shell: the unmatched row (2||BBB) is followed by extra rows (2||BBB|AAA|E3..E5) in both queries. The injection removes the cursor clear in OP_NullRow, so a later OP_Next continues from a stale position instead of finding no more rows.
