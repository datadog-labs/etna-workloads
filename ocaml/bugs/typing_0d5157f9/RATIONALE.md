# Rationale
File: ocaml/typing/typedecl.ml, function `transl_package_constraint`.
The fix (hunk `@@ -1834,6 +1834,33 @@ let transl_with_constraint ...` in typing/typedecl.ml, adding the package-constraint
translation that computes immediacy via `Typedecl_immediacy.compute_decl`, used by
typemod's `merge_package`) is reverted by dropping the immediacy computation:
the declaration is returned with `type_immediate = Unknown`, so
`(module S with type t = string)` where `t [@@immediate]` is no longer rejected.
Today's code differs from fix.diff, so this is a re-expression.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest`.
Result: pr6293_bad.ml passed; package_constraint.ml failed.
