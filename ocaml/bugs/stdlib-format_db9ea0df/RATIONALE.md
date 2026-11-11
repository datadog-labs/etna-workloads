# Rationale
Hunk: ocaml/stdlib/camlinternalFormat.ml, in the parser for formatting literals after '@': removed the `| '@' -> ... Formatting_lit (Escaped_at, ...)` case.
So "@@" falls to the generic `Scan_indic '@'` case and prints "@@" instead of "@".
Reverses fix.diff hunk `@@ -1181,6 +1181,9 @@ let mkprintf ...` in stdlib/format.ml (the `| '@' -> outc '@'` case); Format's printf is now implemented in CamlinternalFormat. The doc hunks (format.mli) and Changes are not reverted.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh` -> pr6024.ml failed (output "@-@@-" instead of "@-@-").
