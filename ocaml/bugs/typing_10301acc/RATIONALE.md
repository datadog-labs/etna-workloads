# Rationale
File: ocaml/typing/includecore.ml, `compare_constructor_arguments` (Cstr_tuple case).
Reverses fix.diff hunk `@@ -171,9 +171,9 @@ let rec compare_constructor_arguments ...`: instead of one
`Ctype.equal env true (params1 @ arg1) (params2 @ arg2)` call over all args, each argument is compared
separately with `(ty::params)`, so type variables aren't consistently matched across args (PR#7378).
The second fix hunk (compare_records, `-217`) is already in the equivalent state in today's code
(`params1 @ [ld_type]`), so was not touched.
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> tests/typing-gadts/pr7378.ml fails.
