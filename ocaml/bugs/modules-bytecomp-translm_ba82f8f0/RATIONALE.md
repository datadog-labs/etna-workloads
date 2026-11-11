# Rationale
Hunk: ocaml/lambda/translmod.ml, `init_shape_struct`: removed the
`| Sig_value(_, {val_kind=Val_prim _}, _) :: rem -> init_shape_struct path env rem` case.
Primitives (externals) in a recursive module signature now hit the `Sig_value _ -> assert false` case.
Reverses the fix.diff hunk `@@ -197,15 +197,19 @@ let init_shape modl =` in bytecomp/translmod.ml (the added Val_prim skip case).
(The Val_reg pattern and the assert-false catch-all are kept; the fix's catch-all was part of the same hunk.)

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: pr7182_ok.ml => failed (ocamlc.byte exit code 2, assertion failure).
