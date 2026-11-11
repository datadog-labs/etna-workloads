# Rationale
Hunk: ocaml/typing/untypeast.ml, `value_binding`. Reverts the fix hunk
`@@ -387,9 +387,17 @@ let case : type k . mapper -> k case -> _ = ...`: today's code extracts a
`Ppat_constraint(pat, Ptyp_poly)` into `Pvc_constraint`; I restored the original
`Vb.mk ~loc ~attrs (sub.pat ...) (sub.expr ...)`, so the constraint stays in the pattern
(printed as `let (foo : 'a . 'a -> 'a) = ...`).
The test hunk in test_untypeast.ml is not edited (testsuite is off-limits).

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> test_untypeast.ml failed.
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: still failed.
