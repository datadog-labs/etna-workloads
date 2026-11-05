# Rationale

## src/backend/access/gist/gistget.c, gistindex_keytest()
Traces to the fix.patch hunk "Assume distance computes as null" in gistget.c. The fix stores a NULL
distance as value 0.0 with isnull=true. I restored the old behaviour: a NULL distance becomes
+Infinity with isnull=false. NULL distances are then indistinguishable from real infinite
distances. The null-aware code in pairingheap_GISTSearchItem_cmp and in
index_store_float8_orderby_distances is never triggered. KNN-GiST then returns Infinity instead of
NULL and orders NULLs wrongly.

## Failing oracle case
src/test/regress||create_index
