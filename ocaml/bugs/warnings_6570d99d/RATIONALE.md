Hunk: ocaml/utils/warnings.ml, warning 57 `ref_manual` changed from [13;5;4] to [12;5;4] (wrong chapter in manual reference).
Reverses fix.diff hunk `@@ -496,7 +496,7 @@ let message = function` (manual section 9.5 -> 8.5, wrong chapter). Today's code uses Misc.print_see_manual with a ref list instead of literal text.
Ran: make -j8 && make -j8 ocamltest && sh run-oracle.sh -> ambiguous_guarded_disjunction.ml fails. Final make clean + rebuild + oracle: same failure.
