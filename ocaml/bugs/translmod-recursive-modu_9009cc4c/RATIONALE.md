# Rationale
Hunk: ocaml/lambda/translmod.ml, init_shape_struct: removed the case
`Sig_value(_, {val_kind=Val_prim _}, _) :: rem -> init_shape_struct path env rem`.
Reverses fix.diff hunk `@@ -215,15 +215,19 @@ let init_shape modl` in bytecomp/translmod.ml (the fix added that case; primitives now hit `assert false`).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh.
Result: typing-modules-bugs/pr7182_ok.ml fails (ocamlc exits 2, assertion failure).
