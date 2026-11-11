# Rationale
Bug (MPR#7818): local aliases in functor argument types were no longer removed.

Hunks, all in ocaml/typing/typemod.ml (reversing fix.diff typemod.ml hunks):
1. In `transl_modtype_aux`, `Pmty_functor` uses `transl_modtype` instead of `transl_modtype_functor_arg`
   - reverses `@@ -762,7 +766,7 @@ ... Pmty_functor(param, sarg, sres)`.
2. In `type_module_aux`/functor typing (`Pmod_functor`), uses `transl_modtype` instead of `transl_modtype_functor_arg`
   - reverses `@@ -1342,8 +1346,8 @@ ... Pmod_functor(name, smty, sbody)`.
3. Removed the now-unused `transl_modtype_functor_arg` definition
   - reverses `@@ -746,6 +746,10 @@ let rec transl_modtype`.
(The approx_modtype call to Mtype.scrape_for_functor_arg and mtype.ml are left in place.)

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: pr7818.ml => failed (expect diff).
