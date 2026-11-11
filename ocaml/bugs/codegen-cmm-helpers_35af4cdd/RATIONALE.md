Edited ocaml/asmcomp/cmm_helpers.ml (two hunks):
1. mk_compare_floats: bind a1 outside, a2 inside again (left-to-right). Reverses fix hunk `@@ -291,16 +291,16 @@ let mk_compare_ints` (its mk_compare_floats part).
2. stringref_safe: bind "str" arg1 outside, "index" inside. Reverses hunk `@@ -2284,8 +2284,8 @@ let stringref_unsafe`.
Commands: make -j8 && make -j8 ocamltest && sh run-oracle.sh -> tests/asmcomp/evaluation_order.ml failed. Final make clean + rebuild + oracle: still failed.
