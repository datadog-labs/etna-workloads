# Rationale
One hunk, ocaml/typing/typeclass.ml, `class_type_field`, `Pctf_attribute` case.
It now runs `warning_attribute x` inside `mkctf_with_attrs`, i.e. inside `Builtin_attributes.warning_scope`, so a `[@@@warning ...]` in a class signature is undone at the end of the field and does not apply to later fields.
This reverses the fix hunk `@@ -276,54 +276,56 @@ let make_method ...`. That hunk wrapped the whole of class_type_field, including Pctf_attribute, so attributes were preserved. Today's code is structured differently, so I re-expressed the change in the Pctf_attribute case.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`.
Result: typing-warnings/disable_warnings_classes.ml fails.
