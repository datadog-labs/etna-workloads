# Rationale

Bug re-introduced: PR#5175, "in bigarray accesses, make sure bigarray expr is evaluated only once".

## Hunks (all in ocaml/asmcomp/cmm_helpers.ml; this is today's home of cmmgen.ml's code)
1. `bigarray_get`: removed the `bind "ba" b (fun b -> ...)` wrapper. This reverses fix.diff hunk
   `@@ -580,32 +580,34 @@ let bigarray_word_kind = function` in asmcomp/cmmgen.ml (the `bigarray_get` part).
   The bigarray expression is now substituted several times by `bigarray_indexing`, so it is evaluated several times.
2. `bigarray_set`: removed the same wrapper. This reverses the `bigarray_set` part of that same hunk.

## Build and test
`cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh` -> pr5115.ml failed (native: duplicated "***EXEC***" output).
Final `make clean && make -j8 && make -j8 ocamltest` then `sh run-oracle.sh` -> pr5115.ml still fails.

RESULT: injected
