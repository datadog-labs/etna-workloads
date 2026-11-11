# Rationale
Hunk: ocaml/typing/includemod.ml, `try_modtypes`, case `(Mty_ident p1, Mty_ident p2)`: removed
`let p1 = Env.normalize_modtype_path env p1 in`, so the left identifier is no longer
resolved/expanded before comparison. A module type abbreviation (`module type T = M.T`) on the
left then isn't expanded during substyping.
Reverses fix.diff hunk `@@ -158,10 +162,10 @@ let rec modtypes ...` (try_modtypes: expansion of `Mty_ident p1` before
the `(_, Mty_ident p2)` case). Today's code has been restructured, so this is the equivalent.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr6240_ok.ml failed
("Module types do not match: M.T does not include T").
