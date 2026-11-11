# Rationale
Changed ocaml/typing/typecore.ml (type_argument): re-added
`if is_nonexpansive texp then func texp else` before the "let-expand to have side effects" block.
This reverses fix.diff hunk `@@ -4136,7 +4136,6 @@ and type_argument ?recarg env sarg ty_expected' ty_expected =`
(which removed that line). Optional-arg eta-expansion no longer binds the argument by let when it is considered nonexpansive, so `r.contents`/`raise Exit; f1` lose CBV semantics.
Commands: make clean && make -j8 && make -j8 ocamltest; sh run-oracle.sh -> tests/basic/pr7657.ml failed (prints FAIL / f2 diff vs reference).
