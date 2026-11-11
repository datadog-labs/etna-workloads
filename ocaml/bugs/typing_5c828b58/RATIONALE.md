# Re-introducing the bug fixed by 5c828b5 (#2235)

Upstream fix: "Assume that module names that are not in `Env.t` are persistent".
Before the fix, when the compiler looked up a global module identifier it only
searched the environment table, so a persistent unit name that was not in that
table could not be resolved (the error was "Cannot find address for ..."). The
environment attached to the components of a loaded .cmi was also built only from
that cmi's import list (crcs), so it was incomplete.

All changes are in `ocaml/typing/env.ml`.

## Hunk 1 – `sign_of_cmi` (components of a loaded cmi)
Reverses the fix hunk `@@ -771,15 +778,9 @@ let acknowledge_pers_struct check modname`
(the fix removed the `add_imported_persistent` fold over `crcs` and passed `empty`).
Today this code lives in `sign_of_cmi`. I put back an environment built by folding
over `cmi.cmi_crcs`, which adds each imported name to the module table as
`Mod_persistent`, and that environment is now used as `cm_env` instead of `empty`.
The entries are added with `IdTbl.add` directly. That matches what 2019's
`add_persistent_structure` did. Today's `add_persistent_structure` skips
"non-material" additions under `-no-alias-deps` (#9991). Calling it here made the
stdlib fail to build, which would be a failure unrelated to this bug.

## Hunk 2 – `find_module_address`
Reverses the fix hunk `@@ -1061,12 +1062,9 @@ let rec find_module_address path env`
(the fix replaced `IdTbl.find_same id env.modules` with `find_same_module`, which
falls back to "persistent", and simplified `Persistent -> Aident id`).
Today the `Pident` case uses `find_ident_module`, which goes through
`find_same_module` and its fallback. I put back the pre-fix logic: look up with plain
`IdTbl.find_same` (raises `Not_found` if the name is missing). `Mod_persistent` gives
`Aident id` unless the name is the current unit, in which case it raises `Not_found`.

Fix hunks NOT reverted:
- `find_module_descr` / `find_module` (`@@ -916,7` and `@@ -1019,7`)
- `lookup_module_descr_aux` (`@@ -1263,11`), now `find_same_module` / `find_name_module`

Today's `-no-alias-deps` handling (#9991) depends on that fallback for every
lookup in the current environment. Reverting it everywhere broke the stdlib build
("type CamlinternalFormatBasics.format6 is unavailable"), so I put those back as
they were. That attempt is logged below.

## Effect
With `-no-alias-deps`, an alias whose target unit is not in the current
environment's module table can no longer get an address. Example: `module D' = D`
in `aliases.ml`, where `D` is a persistent unit that was not added to the table.
Compiling fails with `Fatal error: Cannot find address for: D'.something`. This
is the same failure the fix removed. `gpr2235.ml` still passes with today's code:
the imports now recorded in the cmi make the cmi environment complete enough for
that test.

## Commands run and results
- First try: revert `find_same_module` to plain `IdTbl.find_same`, plus hunk 1.
  `make -j8` failed while building the stdlib (format6 unavailable), so I abandoned it.
- Second try: hunk 2 plus hunk 1 using `add_persistent_structure`. The stdlib build
  failed with "Cannot find address for: Stdlib.Array", so I abandoned it.
- Final version (above), checked from scratch:
  `cd ocaml && make clean && make -j8 && make -j8 ocamltest` gave exit 0.
  `sh run-oracle.sh` gave:
  - tests/no-alias-deps/aliases.ml => failed (`Fatal error: Cannot find address for: D'.something`)
  - tests/no-alias-deps/gpr2235.ml => passed

RESULT: injected
