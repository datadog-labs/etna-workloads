# Rationale
One hunk, `ocaml/typing/typemod.ml`, in `type_package`: when computing the constrained package types (`fl'`), use the type's manifest (`decl.type_manifest`) if present, else the path constructor.
Reverses the hunk `@@ -1023,16 +1024,33 @@ let rec get_manifest_types` of `typing/typemod.ml` in fix.diff. That hunk replaced the manifest-based `tl'` (`get_manifest_types`) with path-based types `Pdot(mp,name)`. Today's code already has the path-based form, so this re-expresses the old manifest-based behaviour.
Other fix hunks (narrow/widen in typecore, the Scoping_pack error) were not reverted. Removing the Scoping_pack check breaks the stdlib build, and the narrow/widen change has no effect in today's code.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: pr5332.ml passed, implicit_unpack.ml failed.
