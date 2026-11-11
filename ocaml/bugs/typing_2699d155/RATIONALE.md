# Rationale
Hunk: ocaml/typing/typecore.ml, `is_inferred`: removed the line `| Pexp_sequence (_, e) -> is_inferred e`.
Reverses fix.diff hunk `@@ -2958,8 +2959,10 @@ and type_argument env sarg ty_expected' ty_expected =`
(which added Pexp_sequence to is_inferred, PR#6352). Other parts of that hunk already exist or are unrelated/cosmetic.
Without it, `foo ((); g)` no longer gets optional-arg elimination.
Commands: make -j8 && make -j8 ocamltest && sh run-oracle.sh -> typing-misc/labels.ml failed.
Final: make clean && make -j8 && make -j8 ocamltest; run-oracle.sh -> labels.ml failed.
