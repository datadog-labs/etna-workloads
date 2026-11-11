# Rationale
Fix: PR#6872, hunk `@@ -282,6 +282,7 @@ extract_concrete_record` in typing/typecore.ml: added a
`Type_open -> (p0,p,[])` case to `extract_concrete_variant`, so that an expected type `exn`
(open type) still provides disambiguation info.

Today's code: `extract_concrete_variant` already has that case (kept, unchanged). Removing it
globally makes the compiler unable to compile itself (e.g. `Unify _` patterns in ctype.ml),
so the bug is re-introduced narrowly: in `type_construct` (typing/typecore.ml), when the
expected type is an open type (exn) and the constructor has no argument, the result is `None`
(no type-directed info), as before the fix (the old code raised Not_found for Type_open).
This is the single hunk changed.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: pr6872.ml => failed (`raise A` yields Warning 41 + type error instead of Warning 42).
