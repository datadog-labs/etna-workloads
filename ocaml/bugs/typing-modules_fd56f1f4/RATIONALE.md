# Rationale
One hunk, ocaml/typing/typemod.ml, `Merge.merge_type`'s `replace` computation.
The fix (hunk `@@ -716,22 +716,25 @@ module Merge`) made non-destructive `with type` skip the
post-processing that rejects constrained types (`if destructive then ... else fun s _ -> s`).
In today's code this is `if not destructive then None else ...`. I reverted it for the
non-alias case: the `params_are_constrained` check now runs (and raises
With_cannot_remove_constrained_type) even when non-destructive; the non-destructive result is still None,
and the alias case is unchanged. (Removing the guard entirely changed stdlib .cmi files and broke the build.)

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), `sh run-oracle.sh`:
typing-modules/merge_constraint.ml fails (expected output differs: the "Destructive substitutions are not supported" error is back).
