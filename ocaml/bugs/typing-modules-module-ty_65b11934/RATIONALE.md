# Rationale
One hunk: ocaml/typing/mtype.ml, `scrape_for_type_of` (remove_aliases branch): the `exclude` predicate
is now always true (`Ident.Set.mem id excl || true`), so no alias is ever removed by `module type of ... [@remove_aliases]`.
Reverses the fix.diff hunk `@@ -272,3 +272,109 @@ and contains_type_item env = function` in typing/mtype.ml
(alias removal from signature for `module type of`, PR#6307); today's equivalent is the [@remove_aliases] path.
The translmod/camlinternalMod hunks of the fix are already absent in today's code (Mty_alias raises), so nothing to revert there.
Result: `module F2 = F(L2)` in typing-modules/aliases.ml fails to typecheck.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh` -> aliases.ml => failed.
