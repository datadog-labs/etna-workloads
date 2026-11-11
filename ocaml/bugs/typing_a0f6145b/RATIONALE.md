# Rationale
Fix PR#6944 (`let module X = Path in` not typed as alias). Since 2015 `let module` is desugared into
`Pexp_struct_item`, typed via `Typecore.type_str_item` -> `Typemod.type_str_item` -> `Pstr_module`,
which uses `~alias:true`; the old `Typecore.type_module := type_module_alias` hook is now only for module variables.
Edits, all in ocaml/typing/typemod.ml:
- `type_str_item` gets `?(alias = true)` and its `Pstr_module` case passes `~alias` to `type_module`; the wrapper
  `type_str_item` used by Typecore (local items) passes `~alias:false`. Reverses hunk `@@ -1457,7 +1457,7 @@ and type_structure` / `@@ -1548,7 +1548,7 @@ let type_package` in spirit: local module bindings are no longer typed with ~alias:true.
  (Original `Typecore.type_module := type_module_alias` line left as is; it already matched the fix.)
Result: pr6944_ok.ml fails ("Map.Make(S).t would escape its scope").
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> failed; final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh -> failed.

Addendum: with a blanket `~alias:false` for local items the clean build broke (tools/ocamltex does
`let module P = Parsetree`, an interface-only unit, which then needs an implementation at link time).
So the `Pstr_module` case computes `alias = alias || (module path denotes a signature with no values)`;
local `let module S = String` (has values) is thus no longer typed as an alias, as before the fix.
Final: `make clean && make -j8 && make -j8 ocamltest` succeeded (exit 0); run-oracle.sh: pr6944_ok.ml => failed.
