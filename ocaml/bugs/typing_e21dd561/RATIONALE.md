# Rationale
Hunk: ocaml/typing/includecore.ml, `Variant_diffing.compare_constructors`: in the `Some r1, Some r2` case,
`compare_constructor_arguments` is called with `params1 params2` instead of `[r1] [r2]`.
Reverses fix.diff hunk `@@ -183,18 +183,21 @@ and compare_variants env params1 params2 n cstrs1 cstrs2 =`
(which made GADT constructor args compared against the return types `[r1] [r2]`).
Effect: pr7160 `type 'a tt = 'a t = ... Same : 'l1 t -> 'l2 tt` is wrongly accepted.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-gadts/pr7160.ml fails.
Final `make clean` + rebuild + run-oracle.sh: pr7160.ml fails.
