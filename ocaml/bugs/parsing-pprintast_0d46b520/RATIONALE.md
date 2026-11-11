# Rationale
One hunk, ocaml/parsing/pprintast.ml, `extension_constructor`, `Pext_rebind li` case: the format now prints
attributes between the name and `=` (`A[@a] = M.A`) instead of after the longident.
Reverses fix.diff hunk `@@ -1587,9 +1587,9 @@ and extension_constructor ctxt f x =` (Changes/test hunks not applicable).
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`; parsetree/test.ml fails (printed output differs), locations_test.ml passes.
