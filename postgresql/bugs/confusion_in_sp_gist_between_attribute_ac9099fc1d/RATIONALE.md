# Rationale

All hunks are in src/backend/access/spgist/spgscan.c and trace to the spgscan.c hunks of fix_impl.patch.

1. `spgbeginscan` ("@@ -314,8 +318,21 @@" hunk): the fix built the index-only-scan result tuple descriptor with the key column typed as attType. I restored `reconTupDesc = xs_hitupdesc = RelationGetDescr(rel)`. The index column has the leaf storage type, so index-only scans return values labelled with the wrong type when attType != leafType. In today's code the fix lives in `getSpGistTupleDesc(rel, &attType)`, so I only changed the call site.
2. `spgFreeSearchItem` ("@@ -81,7 +81,10 @@" hunk): restored the unconditional `attLeafType.attbyval` test. Leaf items hold attType values, so the wrong by-value flag is used.
3. `spgNewHeapItem` ("@@ -447,9 +464,10 @@" hunk): restored the copy of leafValue using `attLeafType` byval/len instead of `attType`.

Failing oracle case: src/test/modules/spgist_name_ops||spgist_name_ops. rangetypes still passes.
