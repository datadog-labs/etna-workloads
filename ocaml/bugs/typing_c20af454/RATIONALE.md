# Rationale
One hunk, ocaml/typing/includemod.ml, `try_modtypes`, case `(Mty_ident p1, Mty_ident p2)`:
`p2` is no longer passed through `Env.normalize_modtype_path` (only `Subst.modtype_path`).
So a module type abbreviation (`module type T = M.T`) on the right side is not expanded
during subtyping. This reverses the fix.diff hunk `@@ -185,10 +189,10 @@ and try_modtypes` in
typing/includemod.ml, which made module-type abbreviations expand (PR#6240). The exact
fix shape (case reordering) is subsumed in today's code by the ident/ident case, so the
bug is re-expressed there.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: pr6240_ok.ml fails ("T does not include T"); aliases.ml passes.
