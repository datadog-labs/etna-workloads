# Rationale
Hunk: ocaml/typing/typedecl_unboxed.ml, `get_unboxed_type_representation env ty` wrapper: fuel changed 100 -> 100000.
Reverses fix.diff hunk `@@ -132,7 +132,8 @@ let rec get_unboxed_type_representation env ty fuel =` (typing/typedecl.ml; the function has since moved to typedecl_unboxed.ml). The comment was also removed.
Effect: `type 'a b = B of 'a b b [@@unboxed]` (PR#7424) diverges / is killed (exit -9) in tests/typing-unboxed/test.ml.
Commands: make -j8 && make -j8 ocamltest && sh run-oracle.sh -> typing-unboxed/test.ml failed. Final make clean + rebuild + oracle: same failure.
