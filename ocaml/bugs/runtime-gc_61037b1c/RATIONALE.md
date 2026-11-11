# Rationale
Hunk: ocaml/runtime/weak.c, `ephe_get_field_copy`: removed the block
`if (Tag_val(val) == Custom_tag) { darken; copy = val; goto some; }`.
Reverses fix.diff hunks `@@ -285,7 +285,8 @@ caml_ephe_get_key_copy` and `@@ -326,7 +330,8 @@ caml_ephe_get_data_copy`
(custom blocks excluded from copying, plus the darken in the else branch; today's code unifies both in one function).
Custom blocks (e.g. Bigarray) are now shallow-copied by Weak.get_copy / Ephemeron *_copy.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> weak_bigarray test fails (b.(0) = 33 instead of 42).
