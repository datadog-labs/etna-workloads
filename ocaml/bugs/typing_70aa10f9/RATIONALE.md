# Rationale
All changes are in ocaml/typing/ctype.ml, reversing the `typing/ctype.ml` hunks of fix.diff (#10348):
- `@@ -2162,13 +2162,10 @@ let reify env t =` (is_newtype replaced by find_expansion_scope with manifest check): restored `is_newtype` and made `find_expansion_scope` plain `type_expansion_scope` again (the `generic_level` for no-manifest was removed).
- `@@ -2427,9 +2424,6 @@` (removal of old find_expansion_scope): merged with the above; the function stays at its current location.
- `@@ -2636,18 +2630,8 @@ let rec unify` : restored the old `Tconstr(p1,[],_), Tconstr(p2,[],_)` newtype-only case in `unify` instead of the generic `unify2_rec` call.
- `@@ -2656,13 +2640,34 @@ and unify2`: removed `unify2_rec` (lazy GADT equation expansion); `unify2` still calls `unify2_expand`.
Tests: expected-output changes in testsuite hunks are not touched.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> ambiguity.ml, or_patterns.ml, pr10348.ml, pr7618.ml, test.ml, inclusion_errors.ml fail. Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: failures persist.
