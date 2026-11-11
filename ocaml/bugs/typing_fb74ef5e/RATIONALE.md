# Rationale
Hunk: ocaml/typing/typemod.ml, `Merge.merge_module` (non-destructive branch):
`Mtype.strengthen_decl ~aliasable:false sig_env md'' path` -> `~aliasable sig_env md'' path`.
Reverses fix.diff hunk `@@ -198,7 +198,8 @@ let merge_constraint` (typing/typemod.ml), which made `S with module M = H'`
strengthen without introducing an alias (PR#6365). In today's code that is expressed via `~aliasable:false`;
reverting lets an alias to H' be introduced: `S'` prints `sig module M = H' end`.
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> aliases.ml failed (expected).
