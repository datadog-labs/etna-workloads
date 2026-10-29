# Rationale

All changes are in `tree/ext/fts3/fts3_snippet.c` (the `sqlite3Fts3GetVarintBounded` helper in fts3.c still exists, since it is used elsewhere in 3.54.1).

1. `fts3MatchinfoSelectDoctotal`: reverses the hunk that added the `n==0` check, the `a==0` NOMEM check, the bounded varint read and the `a>pEnd` check. Restored: unbounded `sqlite3Fts3GetVarint` and only the `nDoc==0` check. (`n`/`pEnd` are still computed so signatures are unchanged.)
2. `FTS3_MATCHINFO_AVGLENGTH` loop in `fts3MatchinfoValues`: removes the `a>pEnd` -> SQLITE_CORRUPT_VTAB check added by the fix.
3. `FTS3_MATCHINFO_LENGTH` loop: back to unbounded `sqlite3Fts3GetVarint` with no `a>pEnd` check, so a truncated %_docsize blob is read past its end.

## Oracle failures
fts4aa-5.20 (truncated docsize returns garbage instead of corrupt error), 5.40, 5.50, 5.60 (truncated %_stat blob returns a result instead of corrupt error); 5.70 (empty %_stat blob) crashes the run (NULL blob dereferenced) so the output ends there.
