# Rationale
File: src/backend/utils/adt/tsvector_op.c, function tsvector_delete_by_indices().
Traces to the fix.patch hunk that sorts and de-duplicates indices_to_delete (the qsort/dedup block).
The dedup step (qunique) is removed, leaving only the sort. With duplicate array entries (e.g. ts_delete(v, ARRAY['a','a'])),
indices_count counts duplicates, so tsout->size = tsv->size - indices_count is too small, and the output is corrupted
(the duplicate index is never matched again, so extra lexemes are copied beyond the declared size).

Failing oracle case: src/test/regress||tstypes
