# Rationale
Hunk: ocaml/parsing/pprintast.ml, `simple_pattern`: removed the `| Ppat_open (lid, p) -> ...` case
(reverses fix.diff hunk `@@ -409,6 +409,14 @@ and simple_pattern ctxt ...`). Today's code had a slightly
different guard (`"true"|"false"`, `None`), so the whole case was removed. Without it, pattern-open
falls to `paren true (pattern ctxt)`, which recurses endlessly, so `-dsource`/Pprintast on `M.(x)` patterns hangs.

Commands: `make -j8 && make -j8 ocamltest` (OK), then `sh run-oracle.sh`:
locations_test.ml passed; tests/parsetree/test.ml hung (killed by timeout, no "passed") => fails.
I did not repeat a final `make clean` rebuild because of time limits; the incremental build was from the final source.
