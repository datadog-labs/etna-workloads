# Rationale
All changes are in src/backend/access/brin/brin.c.

1. `union_tuples()`: removed the block that checks `bt_empty_range` of "b" and "a" (skip the merge if "b" is empty; copy "b" into "a" if "a" is empty). Traces to the fix_impl.patch hunk `@@ -1606 +1617` in union_tuples. Without it, an empty placeholder range is merged key by key as if it held real values/NULL flags, so the summary is wrong.
2. `add_values_to_range()`: removed the block that, after the opclass addValue call, sets `bv_hasnulls = true` when the range had NULLs (`has_nulls`) and the opclass cleared both flags. Traces to the `@@ -1753` hunk. Without it a range that already contained NULLs loses its NULL flag when a non-NULL value is added. The `has_nulls` local is left in place and is now unused.

Failing oracle case: src/test/modules/brin||summarization-and-inprogress-insertion
