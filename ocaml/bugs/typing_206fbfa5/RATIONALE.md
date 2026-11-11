# Rationale
File: ocaml/typing/typemod.ml, `Signature_names.check_item`.
Change: `Shadowable {self=id; group=ids; loc}` -> `group=List.filter (Ident.same id) ids`, so the shadowable group contains only the element itself, not its ghost companions.
Reverses the fix.diff hunk `@@ -1083,24 +1105,35 @@ end = struct` (group of items removed together on shadowing; previously `Shadowable (id, loc)` only). The other hunks are still in the code but have no effect now.
Effect: `include C; type c` only hides the ghost type, breaking the class (assertion failure in ctype).
Commands: make -j8 && make -j8 ocamltest; sh run-oracle.sh -> ghosts.ml failed, shadow_all.ml passed. Final make clean + rebuild + oracle: same.
