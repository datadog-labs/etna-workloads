# Rationale

Fix (ticket #3139): in the LIKE optimizer, for NOCASE patterns ending in '@%', set isComplete=0 so the full LIKE still runs (incrementing '@' lands in the alphabetic range where case folding breaks the range bound).

Change: tree/src/whereexpr.c (exprAnalyze, LIKE/GLOB block) — removed `if( *pC=='A'-1 ) isComplete = 0;`, the modern form of the fix's `if( c=='@' ) isComplete = 0;`. The explanatory comment is left in place. The rest of the code (lower-casing then incrementing) is the same computation as before.

Oracle failures: like-2.64.2 and like-2.64.3 (LIKE with pattern ending '@%' on NOCASE column) return extra rows, because the range constraint alone is trusted and the LIKE term is dropped.
