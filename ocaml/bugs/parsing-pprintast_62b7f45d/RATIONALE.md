# Rationale
One hunk, `ocaml/parsing/pprintast.ml`, function `pattern1`. It reverses the fix.diff hunk
`@@ -559,38 +559,27 @@ and pattern_o​r ctxt f x =` (the `pattern1` hunk).
It restores the local `pattern_list_helper` and the `if txt = Lident "::"` branch in the generic
`Ppat_construct` case, and removes the dedicated `::` case that requires a tuple argument.
The bare constructor `(::)` (no argument) now calls `pattern_list_helper`, which calls `pattern1`,
which calls it again, so it loops forever. The other lines of the fix.diff (Changes entry, test) are not implementation.
Today's code uses `longident_loc` where the fix used `value_longident_loc`, so I kept `longident_loc`.

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), then `sh run-oracle.sh`.
Result: test_untypeast.ml fails. The expect step hangs and ocamltest kills it (exit -9).
