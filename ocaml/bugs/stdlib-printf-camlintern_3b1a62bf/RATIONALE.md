# Rationale
One hunk, ocaml/stdlib/camlinternalFormat.ml, `parse_precision` (legacy mode):
`parse_literal (minus || symb = '-') (str_ind + 1)` became `parse_literal minus (str_ind + 1)`
(and the `as symb` binding was dropped). A `-` inside the precision (`%.-5s`) is thus no longer
treated as left-justification. Reverses fix.diff hunk
`@@ -1979,44 +1983,64 @@ let fmt_ebb_of_string ?legacy_behavior str =`
(the `parse_literal (minus || symb = '-')` part). The rest of the minus plumbing is left in place.

Commands: `cd ocaml && make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: lib-printf/pr6534.ml fails (native and bytecode).
