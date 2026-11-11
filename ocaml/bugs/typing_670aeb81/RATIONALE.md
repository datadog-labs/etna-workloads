# Rationale
One hunk, in `ocaml/typing/includemod.ml`, in `Functor_inclusion_diff.Defs`'s `update`. It reverses the fix hunk
`@@ -1042,12 +1042,11 @@ module Functor_inclusion_diff = struct`.
- Today's code treats `Change` as Delete + Insert, binding both parameters without equating them. I replaced that with the pre-fix behaviour.
- A `Change (Unit, Named (Some id, _))` only binds the parameter.
- A `Change (Named, Named)` equates the two parameters, just like `Keep`. This is the over-optimistic behaviour.
- The other `Change` cases add nothing.
- I also dropped the now-unused `rec` on `update`, because warning 39 is an error in this build.

I did not touch the `Functor_app_diff` hunk of fix.diff.

Commands run:
- `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
- Result: `functors.ml` fails. A later functor-mismatch message prints "2. Module types do not match" where the reference expects "2. Module types $S2 and $T2 match".
