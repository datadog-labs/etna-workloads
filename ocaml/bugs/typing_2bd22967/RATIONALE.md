# Rationale
Single change in ocaml/typing/typemod.ml (Pstr_module case of type_structure):
removed `Mtype.lower_nongen outer_scope md.md_type;` (and the now-unused `let outer_scope = Ctype.get_current_level () in`, which only fed that call and would trip warning-as-error).
Reverses fix.diff hunk `@@ -1291,6 +1291,8 @@ and type_structure ...` in typing/typemod.ml, which added the `Mtype.lower_nongen (Ident.binding_time id - 1) md.md_type` call. Non-generalized type variables in module types are no longer lowered, so the unsound functor application in pr7414_bad.ml is accepted.
Other hunks (Subst nongen_level, Env set_nongen_level) were already absent/rewritten in today's code; lower_nongen itself is left defined.

Commands: `make -j8 && make -j8 ocamltest`, `sh run-oracle.sh`; final `make clean && make -j8 && make -j8 ocamltest` then run-oracle: tests/typing-modules-bugs/pr7414_bad.ml fails (ocamlc accepts program that should be rejected).
