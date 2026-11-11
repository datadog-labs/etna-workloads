# Rationale
Hunk: ocaml/typing/typecore.ml, in type_let's `~before_generalize` callback. The original code (`if maybe_expansive exp then begin lower_contravariant env pat.pat_type; if vars <> None then lower_contravariant env exp.exp_type end`) is changed so the `exp.exp_type` lowering for explicitly polymorphic annotations is dropped.
Reverses fix.diff hunk `@@ -5025,7 +5025,9 @@ and type_let` (the added `if maybe_expansive exp then lower_contravariant env exp.exp_type;` before `generalize_and_check_univars`).
Effect: weak variables get generalized under polymorphic annotations (#9856).

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-poly/poly.ml failed (expected output differs). Final clean rebuild also run.
