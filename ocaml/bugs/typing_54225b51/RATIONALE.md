# Rationale

Fix: MPR#7711 (fix.diff), which adds `has_dummy_method`/`is_self_type` to ctype.ml and, in `unify3`,
links the self type to `t2'` (not the abbreviation `t2`) so the self type is not abbreviated.

Today's `unify3` already contains the pre-fix `link_type t1' t2` (the fix hunk
`@@ -2437,7 +2447,9 @@ and unify3 env t1 t1' t2 t2'` is no longer present). Instead, the modern code is protected
by `expand_head` where the self type is read as an object. The self type can therefore be linked to an abbreviation
(`'not_self r`) without a crash. I removed this protection.

Hunk (typing/ctype.ml, `update_class_signature`): `expand_head env sign.csig_self` -> `sign.csig_self`
(parameter renamed `_env` as it becomes unused). `object_fields` then sees a `Tconstr` and hits
`assert false`, i.e. the MPR#7711 assertion failure. This undoes the effect of the fix hunk
`@@ -2437,7 +2447,9 @@ and unify3` (and the helper hunk `@@ -291,6 +291,16 @@`) that kept the self type from being abbreviated.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: pr7711_ok.ml => failed (Assertion failed in ctype.ml object_fields).
