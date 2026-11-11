# Adapted injection for `best_blame_constraint`: don't filter constraints by sup SCC

Fix: https://github.com/rust-lang/rust/commit/ac922245f0c86657a56d3ca5eff4a1d1b1fcb0a1

# Rationale
File: compiler/rustc_borrowck/src/region_infer/mod.rs, fn `best_blame_constraint`.

In 1.99.1 the old `interesting_to_blame` closure was replaced by a `constraint_interest` ranking, so fix.diff hunks did not apply textually. I re-expressed the removed behaviour:
- Fix hunk `@@ -1983,29 +1983,8 @@` removed `let target_scc = self.constraint_sccs.scc(target_region);` -> re-added `let target_scc = self.constraint_sccs.scc(to_region);`.
- Fix hunk `@@ -2047,30 +2026,14 @@` removed `_ => constraint_sup_scc != target_scc` in the `blame_source` branch of `interesting_to_blame` -> in `constraint_interest`, when `blame_source` and the category is not Return/Yield/TypeAnnotation/boring-like, a constraint whose `sup` SCC equals the target SCC is demoted to interest 4 (not interesting).
- Hunks 1 and 4 (`(path, _)`, comment) are cosmetic.
