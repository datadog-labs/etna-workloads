# Rationale
Hunk: ocaml/typing/typedecl_variance.ml (compute_variance_rec, Tvariant/Reither case).
Reverses fix.diff hunk `@@ -687,8 +687,9 @@ let compute_variance env visited vari ty` (typing/typedecl.ml, now in typedecl_variance.ml):
restores `if List.length tyl > 1 then upper else inter vari upper` (upper == Variance.unknown),
so conjunctive Reither types force invariance and `type +'a t = T : [< `Conj of 'a & sub | ...] -> 'a t` is rejected again.
Other fix hunks (passive_variants in ctype/typecore) were not reverted; the variance one suffices.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr7269.ml failed.
