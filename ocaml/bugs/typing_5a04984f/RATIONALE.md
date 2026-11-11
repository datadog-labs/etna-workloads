# Rationale
Bug (GPR#1329): row_name for polymorphic variant abbreviations was set in expand_abbrev, giving recursive/odd names. Fix moved it to Env.components_of_module.

Hunks:
1. ocaml/typing/ctype.ml (`expand_abbrev_gen`): re-added the "name the variant type" hack after `subst` — reverses fix hunk `@@ -1419,12 +1419,6 @@ let expand_abbrev_gen ...`.
2. ocaml/typing/env.ml (`components_of_module_maker`, Sig_type case): removed the `Btype.set_static_row_name final_decl ...` call (today's name for `Datarepr.set_row_name`) — reverses `@@ -1692,6 +1692,7 @@ and components_of_module_maker`.
The helper definition (datarepr.ml hunk) is left in place (now in btype.ml, unused), harmless.

Tests: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: printing.ml and poly.ml both fail (expected-output differences matching the fix's test changes).

RESULT: injected
