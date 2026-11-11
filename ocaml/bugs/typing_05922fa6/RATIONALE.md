# Rationale
The fix (PR#7152) lowers the level of non-generalized type variables to the binding time of the enclosing module (via Subst.nongen_level in typing/env.ml and subst.ml). In 5.5.2 this logic lives in `Mtype.lower_nongen`, called from typing/typemod.ml in the module-binding case (`type_module_binding`/`type_structure`, `Pstr_module`).

Hunks (typing/typemod.ml):
1. Removed `Mtype.lower_nongen outer_scope md.md_type;` — reverses the fix hunks in typing/env.ml (`set_nongen_level`, `@@ -1317`) and typing/subst.ml (`@@ -125,7 +128,11 @@ let rec typexp`, where `ty.level <- min ty.level s.nongen_level`).
2. Removed the now-unused `let outer_scope = Ctype.get_current_level () in` (avoids unused-variable error).

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: pr7152_ok.ml now FAILS (type error at line 47, previously passed).

RESULT: injected
