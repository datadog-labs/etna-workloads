# Rationale
Hunk: ocaml/lambda/translmod.ml, `record_primitive`: removed the call
`Translprim.check_primitive_arity val_loc p;` and the now-unused `val_loc` binding.
Reverses fix.diff hunk `@@ -175,7 +175,8 @@ let compose_coercions c1 c2 =` in translmod.ml
(`{val_kind=Val_prim p;val_loc}` + the arity check). Primitive arity is no longer checked.
(The toplevel `Tstr_primitive` hunk was not reverted; the check function remains, unused.)
Commands: `make clean; make -j8; make -j8 ocamltest; sh run-oracle.sh` -> tests/typing-misc/external_arity.ml fails
(expected "Wrong arity for builtin primitive "%apply"" error is not produced).
