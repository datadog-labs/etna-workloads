# Rationale

File: src/backend/catalog/index.c, function index_concurrently_create_copy.

The current code has no get_attstattarget() or swap-time copy. The fix is
instead expressed by copying attstattarget when the new index is created. This
traces to the fix.patch hunk in index_concurrently_swap, which copies
attstattarget from the old index to the new one. I removed the loop that read
the old index's attstattarget and now pass NULL as `stattargets` to
index_create(). I also removed the now-unused `stattargets` variable.
The concurrent copy therefore gets default (NULL) statistics targets, so
REINDEX CONCURRENTLY loses ALTER INDEX ... SET STATISTICS settings.

Failing oracle case: src/test/regress||create_index
