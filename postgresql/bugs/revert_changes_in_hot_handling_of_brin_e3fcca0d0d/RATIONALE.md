# Rationale

fix.patch removed the HOT handling for BRIN (amhotblocking=false), so a HOT update no longer had to touch BRIN indexes. Code has since evolved into amsummarizing/summarized_update (TU_Summarizing). To bring back the bug, I made HOT updates ignore summarizing-index columns.

## Hunk
- src/backend/access/heap/heapam.c, heap_update(): in the HOT branch, `summarized_update = true` is no longer set when modified_attrs overlaps sum_attrs. Traces to fix_impl.patch's heapam.c hunk (HOT-blocking bitmap choice for heap_update) and the BRIN amhotblocking=false removal. Because of this, a HOT update that changes a BRIN-indexed column returns TU_None, so the BRIN summary is not updated and can give wrong results or stale stats.

## Failing oracle cases
- src/test/regress||stats
