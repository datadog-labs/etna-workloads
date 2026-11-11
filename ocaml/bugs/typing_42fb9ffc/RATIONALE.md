# Rationale
Hunk: ocaml/typing/subst.ml, `typexp`. Removed the `tm`/`has_fixed_row` computation and the
`if has_fixed_row then ... (* PR#7348 *) else` branch, so substitution no longer rewrites
fixed-row private abbreviation types (`t#row` -> `t`). Reverses fix.diff hunk
`@@ -139,11 +139,20 @@ let rec typexp s ty =` in typing/subst.ml.
Other fix hunks (btype, ctype normalize_type_rec, printtyp) left untouched (helpers stay in use/unused-safe).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-modules/pr7348.ml fails.
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: pr7348.ml still fails.
