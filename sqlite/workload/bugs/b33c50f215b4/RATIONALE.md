# Rationale

Fix hunk reversed: `select.c` in `convertCompoundSelectToSubquery()` set `SF_Converted` on the outer Select.
In 3.54.1 I removed the two lines in `src/select.c` that assert and set that flag
(`assert((p->selFlags & SF_Converted)==0); p->selFlags |= SF_Converted;`).

Without the flag, the two blocks in `resolveSelectStep()` in `src/resolve.c` (move ORDER BY down to the
sub-query, and back) never run. This is the pre-fix state, where those blocks and the flag did not exist.
The ORDER BY of a converted compound SELECT is then resolved against the outer query, not the compound sub-query.
I left the resolve.c blocks and the `SF_Converted` define in place, since they are dead without the flag.

## Oracle failures
selectA-5.2.1, 5.2.3 and 5.2.4 fail with "no such column: t8.a", "no such column: c" and "no such column: t9.c".
Test 5.3 aborts the file with "no such column: c".
The ORDER BY terms that name columns of the compound's component SELECTs, or that carry COLLATE, no longer resolve.
