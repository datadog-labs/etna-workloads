# Re-introduced bug: PR#6934 (nonrec misbehaves with GADTs)
All changes in ocaml/typing/:
- typedecl.ml `enter_type`: removed the check that raised `Nonrec_gadt` for constructors with `pcd_res <> None` in a `nonrec` block. Reverses hunk `@@ -81,7 +82,15 @@ let get_unboxed_from_attributes sdecl`.
- typedecl.ml `type error`: removed `Nonrec_gadt`. Reverses `@@ -58,6 +58,7 @@ type error =`.
- typedecl.ml error reporting: removed the `Nonrec_gadt` message case. Reverses `@@ -2059,6 +2068,9 @@ let report_error ppf = function`.
- typedecl.mli: removed `Nonrec_gadt`. Reverses `@@ -99,6 +99,7 @@ type error =`.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh.
Result: tests/typing-gadts/pr6934.ml fails (the expected error is no longer raised).
