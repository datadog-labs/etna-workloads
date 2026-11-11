# Rationale
Both hunks are in parsing/pprintast.ml and revert parts of fix.diff (PR#7506).
1. `sequence_helper` in `expression`: pattern back to `{pexp_desc=Pexp_sequence(e1,e2);_}` (ignores attributes on the tail sequence). Reverses hunk `@@ -589,7 +598,7 @@ and expression ctxt f x =`.
2. `label_exp`, `Labelled l` case: matches `p.ppat_desc` ignoring attributes, so `~l:(x [@attr])` loses the attribute. Reverses hunk `@@ -444,8 +452,9 @@ and label_exp ctxt f (l,opt,p) =`.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: tests/parsetree/test.ml fails (bytecode and native); locations_test.ml passes.
