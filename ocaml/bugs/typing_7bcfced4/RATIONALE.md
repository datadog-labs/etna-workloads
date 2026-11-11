# Rationale
Fix reversed: hunk `@@ -800,6 +800,7 @@ and transl_recmodule_modtypes loc env sdecls =` in typing/typemod.ml, which added
`Ctype.init_def(Ident.current_time())` so the type level is raised to the idents' scope before translating
recursive module types. In 5.5.2 this is done by `Ctype.create_scope ()` (which calls `init_def`).

Changed hunk: typing/typemod.ml, `transl_recmodule_modtypes`: `let scope = Ctype.create_scope () in`
became `let scope = Ctype.get_current_level () + 1000 in`: idents get a scope higher than the current level
and the level is never raised to it (same state as before the fix).
Result: pr7082_ok.ml fails with `Fatal error: exception Ctype.Unify(_)`.
(The Changes/test hunks of the fix were not touched; test is not edited.)

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` (incremental), then final
`make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`: pr7082_ok.ml failed.
