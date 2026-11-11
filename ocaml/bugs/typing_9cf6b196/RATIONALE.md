# Rationale
Hunk: ocaml/typing/typecore.ml, `Pexp_match` case in type_expect_: the `type_cases Computation ...` call now passes
`(mk_expected ty_expected)` instead of `ty_expected_explained`, dropping the expected-type explanation for match
branches. Reverses fix.diff hunk `@@ -2787,7 +2787,8 @@ and type_expect_` (match passing ty_expected_explained).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; final `make clean && make -j8 && make -j8 ocamltest`, then run-oracle.sh:
type-typing-core-bugs/type_expected_explanation.ml fails.
