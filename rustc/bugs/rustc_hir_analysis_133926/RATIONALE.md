# Adapted injection for Fix const conditions for RPITITs

Fix: https://github.com/rust-lang/rust/commit/4977640c7901d153e7768395b1a3f5d7eccabbf4

# Rationale
File: compiler/rustc_hir_analysis/src/collect/clauses_of.rs (was predicates_of.rs upstream), fn `const_conditions`.
Removed the early `match tcx.opt_rpitit_info(def_id.to_def_id()) { Some(Impl{fn_def_id} | Trait{fn_def_id,..}) => return tcx.const_conditions(fn_def_id), None => {} }`.
Re-expresses fix hunk `@@ -957,6 +957,15 @@ pub(super) fn const_conditions<'tcx>(` (the added "RPITITs inherit const conditions of their parent fn" block).
RPITITs then fall through to the generic HIR-node path and no longer inherit their parent fn's const conditions.
The other fix hunks (explicit_implied_const_bounds restructure, span_bug message) were not reverted; they are refactors/message changes.
