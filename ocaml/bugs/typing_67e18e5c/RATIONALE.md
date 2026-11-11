# Rationale
Hunk: ocaml/typing/typedecl_variance.ml, in compute_variance_type, "Check propagation from constrained parameters":
`if c1 && not c2 || n1 && not n2 then begin` -> `if (c1 && not c2 || n1 && not n2) && not i2 then begin`.
Effect: variance propagation to constrained parameters is only reported when the variable is not injective, so the
variance mismatch errors (e.g. `type +'a t = 'b constraint 'a = 'b q`, `'b t q`) are no longer raised.
Reverses the fix.diff hunk `@@ -576,75 +582,83 @@ ... let compute_variance_type` in typing/typedecl.ml (the new
"Check propagation from constrained parameters" block comparing tvl1/tvl2 variance with codes -1/-2/-3), re-expressed
in today's code (the pre-fix code only checked via the weaker injectivity test). Only an approximation of the old
behaviour, a single-hunk reintroduction.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr5985.ml failed (missing error for
`type +'a s = 'b constraint 'a = 'b t q`), private.ml passed. Final `make clean && make -j8 && make -j8 ocamltest`
then run-oracle.sh: same result.
