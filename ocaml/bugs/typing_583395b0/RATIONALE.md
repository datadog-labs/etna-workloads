# Rationale

Hunk reversed: `typing/mtype.ml` `@@ -44,7 +44,9 @@ and strengthen_sig env sg p pos` in fix.diff. That hunk made
`Val_prim` items (externals) not advance the field position `pos`. In today's code
`Mtype.strengthen_sig` no longer tracks `pos`. Positions are computed in
`typing/env.ml` `components_of_module_maker` (`next_address`), where `Val_prim` items already get
no address and do not advance `pos`.

Change (ocaml/typing/env.ml, one function):
- `Val_prim` items now call `next_address ()` and advance `pos`, so the following items get shifted field offsets.
- This only applies when the components come from an alias (`cm_mty` is `MtyL_alias`) with a `Pdot` path whose head is not a persistent unit.
  Without that restriction the stdlib itself is miscompiled (Stdlib.Sys, Stdlib.Int32 and so on are aliases) and the build breaks.

Result: tests/basic-modules/pr6726.ml (used by main.ml) reads the wrong field and segfaults.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Build succeeded. main.ml failed (run action: exit code -11). The other 4 oracle tests passed.
