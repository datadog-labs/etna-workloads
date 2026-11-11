# Rationale

Fix reversed: "fix principality by expanding local definitions when exporting a value" (2011-03-10).
The fix, in `typing/ctype.ml` `update_level`, hunk `@@ -698,16 +698,18 @@ let rec update_level env level ty =`,
removed `if is_newtype env p then raise Cannot_expand;` and made the level check use the newtype's
definition level adjusted for local equations (`Env.map_newtype_level`). The Env.level_map machinery
no longer exists (replaced by scopes / `type_expansion_scope`), so the same bug is re-expressed on today's code.

## Hunk (only one): `ocaml/typing/ctype.ml`, `update_level`, first `Tconstr` case
- Restores `if (Env.find_type p env).type_is_newtype then raise Cannot_expand;`, so a local newtype is
  never expanded when its level is updated (reverses the removed `is_newtype` line of the hunk above).
- Extends the case's guard so it also fires for newtypes with a local equation (non-constructor manifest)
  whose expansion scope is above the target level (reverses the `Env.map_newtype_level` level
  adjustment, i.e. the notion of "definition level of a local equation"). Without expansion, exporting such a
  type raises a scope escape, as before the fix.

## Commands
`cd ocaml && make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
Result: build OK; tests/typing-gadts/test.ml => failed (expect output differs in existential/object cases
with "The type constructor $a would escape its scope"). Earlier variants without the guard widening passed
or broke the stdlib build (bigarray) and were discarded.
