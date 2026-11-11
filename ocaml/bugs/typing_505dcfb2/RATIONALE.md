# Rationale
Hunk: ocaml/typing/ctype.ml, `is_contractive`: added `|| in_current_module p` to the contractiveness test (so any type constructor defined in the current module counts as a datatype under -rectypes).
Reverses fix.diff hunk `@@ -1491,7 +1491,7 @@ let rec non_recursive_abbrev env ty0 ty =`, which removed `in_current_module p ||` from the "treat as datatype" condition. That function no longer exists in 5.5.2; `is_contractive` is its modern equivalent.
Result: pr5343_bad.ml (module subtyping with `type u = u t` under -rectypes) is accepted instead of rejected.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Results: Tests.ml passed, poly.ml passed, pr5343_bad.ml failed (ocamlc compiles it with exit 0 while it should be rejected).
