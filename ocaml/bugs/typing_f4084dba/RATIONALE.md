# Rationale
Fix hunk `@@ -3613,6 +3613,7 @@ and type_expect_` in typing/typecore.ml added `Mtype.lower_nongen ty.level modl.mod_type;` after typing a local `let module`.
In 5.5.2 local modules are typed as `Pexp_struct_item` / `Pstr_module` in typing/typemod.ml (`type_structure`), where the equivalent call is
`Mtype.lower_nongen outer_scope md.md_type;`. I removed that call and the now-unused `let outer_scope = Ctype.get_current_level () in`.
Effect: weak type variables in local module types are not lowered, so pr7414_2_bad.ml is wrongly accepted.

Commands: `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh` (incremental build, not a final `make clean` rebuild).
Result: typing-modules-bugs/pr7414_2_bad.ml fails (the ocamlc.byte action reports "failed" because the expected compile error no longer occurs).
