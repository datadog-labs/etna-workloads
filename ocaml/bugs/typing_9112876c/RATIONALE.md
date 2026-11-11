# Rationale
File: ocaml/typing/includecore.ml (type_declarations), reverses hunk `@@ -288,6 +288,9 @@ let type_declarations ...` of fix.diff
(which added `need_variance` and an early exit).
1. Removed the `need_variance` definition and `if not need_variance then None else`, so the variance check
   runs for every type pair.
2. Lower-bound variance check `imp abstr (...)` changed to `imp abstr' (...)` (today's equivalent of the old
   behaviour where abstr included private), so private exports with an inferred-lower-bound mismatch via functors are rejected.
Result: tests/typing-modules-bugs/pr7321_ok.ml fails (ocamlc exit 2).
Commands: make clean && make -j8 && make -j8 ocamltest; sh run-oracle.sh -> 1 failed.
