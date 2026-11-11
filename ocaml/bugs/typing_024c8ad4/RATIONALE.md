# Rationale
Hunk: ocaml/typing/typedecl_variance.ml, `compute_variance_rec`, `Reither` case.
Replaced `let v = Variance.(inter vari unknown) in List.iter (compute_variance_rec env v) tyl` with `List.iter compute_same tyl`.
Reverses fix.diff hunk `@@ -573,7 +573,13 @@ let compute_variance env visited vari ty =` (typing/typedecl.ml; code has since moved to typedecl_variance.ml and the fix was refined for PR#7269). Without it, variables in `[< `X of 'a]` are not treated as non-deducible, so PR#6275 is unsound again.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: pr5985.ml fails (output differs from reference).
