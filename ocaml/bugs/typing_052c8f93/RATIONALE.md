# Rationale

Today's code differs from the 2010 GADT branch, so the fix was re-expressed in the current ctype.ml/typecore.ml.

Hunks (all in ocaml/):

1. `typing/ctype.ml`, `reify`: `create_fresh_constr` no longer takes the level of the
   variable. It creates the fresh abstract type at the current level. This reverses
   `@@ -1696,36 +1696,37 @@ let deep_occur` (`create_fresh_constr lev row` / `newty2 lev`).
   The `level` argument at both call sites was dropped.
2. `typing/ctype.ml`, `add_gadt_equation`: removed `duplicate_type destination`. This reverses
   `@@ -2126,12 +2127,15 @@ and unify3` (the `begin_def (); duplicate_type destination; end_def (); generalize`).
   The scope given to the new local equation is `max (Path.scope source) equations_scope + 1`,
   so it is too high. This reverses the same hunk's `source_lev` change (the scope of the
   equation's declaration).
3. `typing/typecore.ml`, `partial_pred`: the equations scope is the current level, not the `~lev`
   argument, which is now ignored. This reverses the
   `@@ -728,33 +728,29 @@ let type_pat` hunk (`partial_pred ~lev`; before the fix the level was the current level).

Effect: omega07.ml fails in the oracle. Typing `onestep` gives a spurious
"it would escape the scope of its equation" error. The diff against the expected output also
shows "Unbound value subst".

Commands: `cd ocaml && make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`.
Result: the build succeeds and the omega07.ml test fails (no "=> passed" line).

Note: hunks 1 and 3 alone did not make the test fail. The failure comes from hunk 2's scope change.
