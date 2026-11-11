# Rationale

One hunk: `ocaml/typing/includemod.ml`, in `modtypes` (case `(Mty_alias p1, _)`), the call
`strengthened_modtypes ~core ~direction ~loc ~aliasable:true env subst mty1 p1 mty2 orig_shape`
now passes `~aliasable:false`.

Reverses the fix.diff hunk `@@ -1404,27 +1412,6 @@ and type_structure` in typing/typemod.ml, and the mtype.ml
`@@ -59,13 +59,18 @@ and strengthen_sig` hunk, which together made the strengthening done when an alias is expanded
turn submodules into aliases (`module N = M.N`). In today's code that is the `~aliasable` flag.
With `false`, an expanded alias's submodules are strengthened only with type equations, not
aliases, so incremental weakening of module aliases fails again (PR#6465).
Also `typing-modules/aliases.ml` shows the pre-fix "Modules do not match ... (module M.N)" error.

Note: the other candidate (`~aliasable:false` for the signature-component check around line 968) made the
stdlib build fail with inconsistent assumptions, so it was not used.

Commands: `make clean && make -j8 && make -j8 ocamltest` (success), then `sh run-oracle.sh`:
tests/typing-modules/aliases.ml fails (output diff shows the old error for `module R' : S = R`).
