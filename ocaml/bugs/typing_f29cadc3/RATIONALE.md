# Rationale

Fix reversed: PR#7438 "disabled 'unused type' warning for #row types".

Hunks (the fix switched `Env.add_type ~check:true` to `~check:false` for `#row` types):

1. `ocaml/typing/typemod.ml`, `check_type_decl`-equivalent (`Some fresh_row_id -> Env.add_type ...`):
   `~check:false` -> `~check:true`. Reverses fix hunk `@@ -125,7 +125,7 @@ let check_type_decl ...`.
2. `ocaml/typing/typemod.ml`, `merge_type` (`Env.add_type ~check:... id_row decl_row env`):
   `~check:false` -> `~check:true`. Reverses fix hunk `@@ -188,7 +188,7 @@ let merge_constraint ...`.
3. `ocaml/typing/env.ml` `check_usage`: today's code has extra guards that independently
   hide #row types from the unused-type warning (skip names starting with `#`, skip ghost locations;
   the row decl is ghost). With only 1+2 the bug was not observable, so I removed the `'#'` name exclusion and
   let ghost `#row` names through the ghost guard. This is the re-expression of "the check
   is enabled for #row types" in today's code (supports hunks 1/2 taking effect).
   Note: the newly-added `Btype.is_row_name` use is only in this guard.
   (Also Typedecl's `add_types_to_env ~check:true` then reports the first row warning.)

Tests/commands: `make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
unused_types.ml => failed (spurious `Warning 34: unused type "t#row"` for Pr7438 case).
Final: `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: failed as expected.
