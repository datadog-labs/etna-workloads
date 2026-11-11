# Rationale
Fix hunk reversed: stdlib/scanf.ml `@@ -1335,18 +1335,10 @@ let scan_format ...` (the fix added `skip_indication`,
making '@' followed by '%'/'@' in a scanf format consume the escaped char rather than a literal '@';
tested by the new test58 in tscanf.ml).
In today's GADT-based scanf, that logic is in `stopper_of_formatting_lit` (ocaml/stdlib/scanf.ml):
for `Escaped_percent` (`@%`) the stopper was `'%', ""`; now `'@', "%"`, i.e. the '@' is treated as a plain
literal/stopper again instead of the escape being handled. Breaks `"%s@%%s"` scanning in tscanf test58.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
tprintf.ml passed; tscanf.ml failed (bytecode and native).
