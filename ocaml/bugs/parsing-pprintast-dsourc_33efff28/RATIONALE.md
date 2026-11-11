# Rationale
File: ocaml/parsing/pprintast.ml, `needs_parens`.
Fix hunk reversed: `@@ -81,13 +81,23 @@ ... let needs_parens ~kind txt` — the fix added `| Type -> false` so `mod` in type context isn't parenthesized. I merged `Type` back into the generic branch (`| Constr | Value | Other | Type ->`), so type identifiers named `mod` print as `(mod)` again under -dsource / Pprintast.
Commands: make -j8 && make -j8 ocamltest && sh run-oracle.sh -> a test fails (parsetree/test.ml diff output).
