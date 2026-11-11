# Rationale
Today's runtime has no compact.c (the OCaml 5 compactor is in runtime/shared_heap.c). The fix hunk
`@@ -122,10 +122,7 @@ static char *compact_allocate (mlsize_t size)` (the check for free target space during compaction)
was re-expressed in the analogous place:
runtime/shared_heap.c, caml_compact_heap, evacuation-set selection loop:
`if (free_blocks >= remaining_live_blocks)` -> `if (free_blocks + 1 >= remaining_live_blocks)`.
This stops one block short of the needed free space, so evacuation can run out of target
blocks when the heap is fully used, and compaction segfaults (pr9853 corner case).
The Changes and test hunks were not reproduced (they are not implementation).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` (also after `make clean`; the final clean rebuild was
interrupted by a tool timeout and completed with a plain `make -j8 && make -j8 ocamltest`, exit 0).
Result: tests/regression/pr9853/compaction_corner_case fails (exit -11, segfault).
