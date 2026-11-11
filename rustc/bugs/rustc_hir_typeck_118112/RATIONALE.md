# Adapted injection for Don't ICE when ambiguity is found when selecting Index implementation in typeck

Fix: https://github.com/rust-lang/rust/commit/273dc22b04411b9c156375d15ad2c8cead2e619e

# Rationale
File compiler/rustc_hir_typeck/src/expr.rs, fn `find_and_report_unsatisfied_index_impl`.
Re-expresses fix hunks `@@ -3064,7 +3064,9 @@` (the `outer_universe`/snapshot param, closure back to `|_|`) and `@@ -3110,11 +3112,23 @@` (removed `self.leak_check(outer_universe, Some(snapshot))?` and the bail-out `if true_errors.is_empty() && !ambiguity_errors.is_empty() { return Err(NoSolution) }`). Ambiguity/higher-ranked leak errors now reach error reporting, giving the ICE/failure again.
The `ocx.eq` argument-order hunk was not reverted (semantically irrelevant).
