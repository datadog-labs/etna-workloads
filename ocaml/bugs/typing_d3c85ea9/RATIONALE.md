# Rationale
File: ocaml/typing/ctype.ml, `local_non_recursive_abbrev`.
Hunk `@@ -1641,18 +1642,20 @@ let rec local_non_recursive_abbrev ...` of fix.diff: the fix added a
default-case traversal (`if strict then iter_type_expr ...` for PR#7374) so that non-constructor
types reached strictly (e.g. via constraints) are checked for recursion. In today's code that is the
`| _ -> if strict || not allow_rec then ... iter_type_expr ...` branch; I restored the old `| _ -> ()`.
Other hunks (strict parameter plumbing, test) are left, since strict is still used elsewhere.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr7374.ml fails.
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: pr7374.ml fails.
