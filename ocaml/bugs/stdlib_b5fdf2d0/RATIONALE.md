# Rationale
Hunks (both in ocaml/stdlib):
- camlinternalLazy.ml: removed `type 'a t = 'a lazy_t` (+ blank line). Reverses fix.diff hunk `@@ -15,6 +15,8 @@` of stdlib/camlinternalLazy.ml.
- camlinternalLazy.mli: removed the same declaration. Reverses `@@ -17,6 +17,8 @@` of stdlib/camlinternalLazy.mli.

Effect: CamlinternalLazy no longer defines `t`, and its source lines shift by 2. The backtrace2 reference output hardcodes camlinternalLazy.ml line numbers, so it no longer matches.
I did not reverse the lazy.ml(i) or camlinternalMod.ml hunks: they would need CamlinternalLazy.t, which would make a dependency-breaking build. That would be a different failure.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: build OK; tests/backtrace/backtrace2.ml fails (line number diffs in camlinternalLazy.ml).
