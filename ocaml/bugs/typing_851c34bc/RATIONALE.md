# Rationale

One hunk, in `ocaml/typing/typedecl.ml` (`transl_type_decl`): the deep per-declaration check
`check_well_founded_decl` is run with a `to_check` predicate that is always false
(`(fun _ -> false)`), so cycles that go through abbreviations of the types being defined (e.g. in
constraints, as in PR#6505) are no longer detected.

Reverses the fix.diff hunk `@@ -990,9 +1048,16 @@ let transl_type_decl env sdecl_list =`, which added the
`List.iter (fun (id, decl) -> check_well_founded_decl ... decl to_check) decls` pass over
the whole declaration (in addition to `check_well_founded_manifest`).
Removing the call entirely made the build fail with inconsistent assumptions
(the check has side effects on type sharing in the stdlib .cmi files), so the call is neutralised instead.

Commands run: `cd ocaml && make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`.
Result: build OK; constraints.ml => failed (the "contains a cycle" errors are no longer reported).
