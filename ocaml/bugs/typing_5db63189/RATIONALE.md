# Rationale
Hunk: ocaml/typing/btype.ml, `type_iterators`'s `it_type_expr` (line ~514).
It no longer calls `try_mark_node` before `it.it_do_type_expr`; it recurses unconditionally.
This undoes fix.diff hunk `@@ -430,6 +432,17 @@ let mark_type_node ty` in typing/btype.ml, which added the
marking `it_type_expr` wrapper (`mark_type_node ty; it.it_do_type_expr ...`) to avoid loops.
In today's code the marking lives in the single `type_iterators mark` function, so the
revert is made there. Cyclic types (e.g. `< m : 'a > as 'a`) then loop forever in
`Mtype.collect_arg_paths` (used by `with module M = M`).
The other hunks (unmark_iterators, Mtype unmark call) are not needed: marks are scoped by `with_type_mark` now.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr6371.ml times out (hang), "=> failed".
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: rc=1, failed.
