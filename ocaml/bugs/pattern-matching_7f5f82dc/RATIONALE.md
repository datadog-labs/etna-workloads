# Rationale
File: ocaml/lambda/matching.ml (only file changed).
- Added `PlainCompat = Parmatch.Compat(struct let equal = Data_types.equal_constr end)` / `plain_compats`: the plain (rebinding-unaware) compatibility, as used before the fix.
- In `up_ok` (the `not (may_compats (General.erase p :: ps) ...)` test) replaced `may_compats` with `plain_compats`. Reverses hunk `@@ -543,37 +541,11 @@ let up_ok_action act1 act2 =` (`up_ok` going from `Parmatch.compats` to `may_compats`; today's code has no exc_insides guard, so the compat call is the part that carries over).
- The other fix sites (ctx_match etc.) are left as-is.
Result: patmatch.ml fails (PR#7661 case: "'c' pas bon pour g false A (should be 'b')").
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> patmatch.ml failed; final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh -> failed.
