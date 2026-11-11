# Rationale
Fix: "Env.lookup_module: don't allow creating loops (#8810)". The fix added `not (Current_unit_name.is s)` to the
`Not_found when !transparent_modules && not load` handler in `lookup_module`. In today's code that guard lives in
`typing/env.ml` in two places (the code was refactored):

1. `find_name_module` (used by `lookup_ident_module`): removed `when not (Current_unit.Name.is name)` from the
   `exception Not_found` case. Reverses hunk `@@ -1087,7 +1087,10 @@ and lookup_module ~load ?loc ~mark lid env : Path.t =`:
   the current unit name is again turned into a persistent module (self-loop `module Loop = Pr8810`).
2. `find_shape`, Module case: removed `&& not (Current_unit.Name.is_ident id)` from the `Not_found` handler so that
   the self-referencing persistent ident no longer crashes with Not_found and the loop compiles (exit 0). Same hunk
   as above (same current-unit guard, in the shape lookup that today's code needs for it).
   Without this, the bug shows up only as a Fatal error with exit 2, so the test would not distinguish.

Tests/Changes hunks of the fix are not touched (test files off limits).

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
pr8810.ml => failed (ocamlc exits 0 instead of 2).
