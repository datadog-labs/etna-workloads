# Rationale
Hunk: ocaml/typing/ctype.ml, `eqtype_row`, Reither/Reither cases.
Reverses fix.diff hunk `@@ -3330,9 +3330,9 @@ and eqtype_row ...`: the `when c1 = c2` guards are removed and
the patterns go back to `Reither(true, [], _), Reither(true, [], _)` and
`Reither(false, t1::tl1, _), Reither(false, t2::tl2, _)`, so conjunctive tags
with differing conjunctive flags are no longer handled (PR#5927).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean` + rebuild + oracle.
Result: tests/typing-misc/polyvars.ml fails (PR#5927 expect test).
