# Rationale

## src/include/access/htup_details.h, heap_getattr()
Traces to the fix.patch hunk in htup_details.h (heap_getattr macro). The fix made heap_getattr
return getmissingattr() when attnum exceeds the tuple's natts, so columns added with a fast
default return their missing value. Reverted: it again sets *isnull = true and returns 0, so
tuples written before ALTER TABLE ADD COLUMN ... DEFAULT read the new column as NULL.

The other hunks (exporting getmissingattr, trigger.c heap_expand_tuple) are not needed to bring the bug back,
and were left alone to keep the change minimal.

## Failing oracle cases
- src/test/regress||fast_default
