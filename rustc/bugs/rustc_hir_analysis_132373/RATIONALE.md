# Adapted injection for Make sure type_param_predicates resolves correctly for RPITIT

Fix: https://github.com/rust-lang/rust/commit/d53ca634532d548ad30cb75af3f93030f1b415f4

# Rationale
File: compiler/rustc_hir_analysis/src/collect/clauses_of.rs, fn `type_param_clauses` (1.99.1 name of the old `type_param_predicates`).
Removed the leading `match tcx.opt_rpitit_info(item_def_id.to_def_id()) { Trait{opaque_def_id,..} => return tcx.type_param_clauses((opaque_def_id.expect_local(), ..)), Impl => unreachable!, None => {} }`.
This re-expresses fix hunk `@@ -764,6 +764,16 @@ pub(super) fn type_param_predicates<'tcx>(` which added that match. Without it, an RPITIT's synthesized assoc-ty def is resolved directly (shorthand `X::Foo` in the RPITIT bound), and the compiler ICEs.
