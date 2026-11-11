# Rationale
Hunk: ocaml/typing/ctype.ml, update_level: guard `Tfield(lab,_,ty1,_) when lab = dummy_method && level < get_scope ty1` changed back to `get_level ty1 > level`.
Reverses fix.diff hunk `@@ -836,8 +837,8 @@ let rec update_level env level expand ty =` (self-escape check by scope instead of level).
Other fix hunks (scope plumbing in typeclass.ml) are not reverted; the level-based check alone reintroduces the principal-mode bug.
Commands: make -j8 && make -j8 ocamltest && sh run-oracle.sh; final make clean + rebuild + run-oracle.sh.
Result: typing-objects/Tests.ml fails (spurious "This pattern cannot match self" errors in principal mode).
