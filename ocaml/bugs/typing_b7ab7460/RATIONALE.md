# Rationale

Fix: PR#6235 "Keep typing of pattern cases independent in principal mode".
The fix's `typecore.ml` hunk `@@ -3325,11 +3330,12 @@ and type_cases ...` delayed the
unification of each case's pattern with the argument type until all patterns
were typed. The first hunk (`Ppat_variant`) is already present in today's code
and was not touched.

Only one file changed: `ocaml/typing/typecore.ml`, in `map_half_typed_cases`
(the successor of `type_cases`).
- `ty_arg'` is now created before the case loop, as an instance of `ty_arg`.
  It was previously a fresh `newvar ()` created just before `unify_pats`.
- Each case is typed against that shared `ty_arg'`, instead of a fresh instance
  of `ty_arg`. This applies only to patterns that contain polymorphic variants
  and no GADTs. Type information from earlier cases therefore flows into later
  patterns. This undoes `unify_pat env pat ty_arg'` being moved out of the loop
  into `List.iter (fun pat -> unify_pat env pat ty_arg') patl`.
- The restriction to polymorphic-variant patterns without GADTs is needed
  because sharing for every case made the stdlib, which is compiled with
  -principal, fail to build.

Result: the `P6235'` case in `typing-warnings/records.ml` no longer gives the
principal-mode output expected by the test.

Commands run: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` while
iterating. The final run was `make clean && make -j8 && make -j8 ocamltest`,
then `sh run-oracle.sh`. The build succeeded and `records.ml` => failed.
