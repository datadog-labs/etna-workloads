# Rationale
File: ocaml/parsing/pprintast.ml
- In `pattern1`, the `Some (vl, x)` case of a constructor pattern with locally abstract types now prints the names with `tyvar_loc` (prints `'a`) instead of a plain name printer (`ident_of_name_loc`). Reverses fix hunk `@@ -446,7 +446,7 @@ and pattern1 ...` (`string_loc` -> `tyvar_loc`). Output becomes `C (type 'a 'b) y`, which is invalid syntax.
- Removed the now-unused helper `ident_of_name_loc` (the today's-code analogue of the fix's `string_loc` addition, hunk `@@ -95,6 +95,8 @@`), because an unused value is a fatal warning.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; final `make clean && make -j8 && make -j8 ocamltest`, then run-oracle.sh: parsetree/test.ml fails (output differs from reference), locations_test.ml passes.
