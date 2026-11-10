# Adapted injection for use Const::eval instead of QueryNormalize in error reporting

Fix: https://github.com/rust-lang/rust/commit/28f39862a8a673d5d162121b8c432a5b82883d3d

File: compiler/rustc_trait_selection/src/error_reporting/traits/fulfillment_errors.rs, fn report_similar_impl_candidates.
Removed the `.map(|mut cand| ...)` step that normalized/const-folded each impl candidate's trait_ref (try_normalize_erasing_regions) before sorting and reporting. Candidates are now shown with unevaluated consts (`core::::array::{impl#30}::{constant#0}`).
Re-expresses the fix hunk `@@ -2028,27 +2027,26 @@` which replaced the query-normalize step with `ct.eval(self.tcx, ParamEnv::empty())` via BottomUpFolder ("Fold the const so that it shows up as, e.g., `10`"); the buggy parent lacked correct const evaluation.
