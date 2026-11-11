# Rationale

The fix (PR#6376) added a check so that `Alias with module N := F(List)` is rejected
(the alias to a non-aliasable path `F(List)` is invalid). In 2014 it lived in
`typing/includemod.ml` (`Invalid_module_alias`). Today that check is done in
`typing/typemod.ml` (`merge_module`, `With_creates_invalid_aliases`), so the
includemod hunks of the fix have no direct equivalent. I removed the modern equivalent.

Hunk: `typing/typemod.ml`, `merge_module`: `let invalid_alias = if (not aliasable) then (Some path) else None in`
became `let invalid_alias = None in` plus `ignore aliasable;`.
It reverses the fix hunks `@@ -190,6 +191,8 @@ ... try_modtypes` (the `raise (Error[... Invalid_module_alias p2])` check on non-aliasable
paths) and the associated error symptom hunks in includemod.ml/.mli, whose role is now played by this check.
The `with` constraint now accepts an invalid alias to `F(List)`.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: tests/typing-modules/aliases.ml fails (the PR#6376 expectation now outputs
`module S : sig module type A = sig module M = F(List) end ...` instead of the error).

RESULT: injected
