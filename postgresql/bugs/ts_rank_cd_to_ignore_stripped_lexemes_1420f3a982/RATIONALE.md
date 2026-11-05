# Rationale

## src/backend/utils/adt/tsrank.c, get_docrep()
Traces to the single implementation hunk of fix.patch (get_docrep, `else` branch for entries with `!haspos`).
The fix skips stripped lexemes (`entry++; continue;`). I reverted that to the old behavior: use a dummy
position (`dimt = posnull.npos; post = posnull.pos;`). Because the current code has no file-level POSNULL
there, I added a local `posnull` (WordEntryPosVector1, npos=1, pos at MAXENTRYPOS-1), as the other
functions in this file do. With this change, stripped lexemes are counted as matches at a fake position
in ts_rank_cd(), which gives wrong ranks.

## Failing oracle cases
- src/test/regress||tsearch
