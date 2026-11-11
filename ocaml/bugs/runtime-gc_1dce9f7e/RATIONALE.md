# Rationale
Hunk: ocaml/runtime/lf_skiplist.c, caml_lf_skiplist_insert: removed the
`atomic_store_relaxed(&new_cell->garbage_next,NULL);` line, so a new cell's
`garbage_next` is left uninitialised (malloc'd memory).
Reverses fix.diff hunk `@@ -354,7 +354,7 @@ int caml_lf_skiplist_insert(...)`, which made the
initialisation of garbage_next explicit (the fix's message: "fix for uninitialised
garbage_next"). A literal revert to a plain `= NULL` assignment is behaviourally identical
and no test fails, so the initialisation is dropped entirely.
Commands: `make clean && make -j8 && make -j8 ocamltest`; `sh run-oracle.sh`
Result: lf_skiplist/test.ml fails (space leak detected, len != v).
