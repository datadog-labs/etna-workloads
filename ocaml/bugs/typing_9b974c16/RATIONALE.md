# Re-introduced PR#6241 (assumed inequality between paths involving functor arguments)

All edits in ocaml/typing/ctype.ml.

1. `mcomp`: the `(Tpackage _, Tpackage _) -> ()` case became
   `(Tpackage p1, Tpackage p2) when Path.same_unsafe p1.pack_path p2.pack_path -> ()`.
   Packages with different paths now fall through to `Incompatible`.
   Reverses hunk `@@ -1991,8 +1991,7 @@ let rec mcomp type_pairs env t1 t2 =`, which dropped the `Path.same p1 p2` guard.
   (Today's code uses `same_unsafe` because `Path.same` is shadowed.)

2. `unify_package`: in the `Error`/`Not_found` cases, always raise Unify, instead of
   tolerating the mismatch in pattern mode (reifying the constraints).
   Reverses hunk `@@ -2398,9 +2397,12 @@ and unify3 env t1 t1' t2 t2' =`, which replaced
   "raise Unify when paths differ" with "in pattern mode, reify and continue".

Effect: the pattern `A` is wrongly judged impossible for `((module A.T),(module B.T)) t`,
so the exhaustiveness warning disappears and `N.f A` segfaults.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: tests/typing-gadts/pr6241.ml fails (expect segfaults, signal 11).
The test passed with only hunk 1 applied, so hunk 2 was needed.

RESULT: injected
