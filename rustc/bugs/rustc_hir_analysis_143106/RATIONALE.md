# Adapted injection for gce: don't ICE on non-local const

Fix: https://github.com/rust-lang/rust/commit/0e32036debd1daba5bd079a47eeaf93ec7da99b3

# Rationale
File: compiler/rustc_hir_analysis/src/collect/clauses_of.rs, fn `is_const_param_default` (inside `const_evaluatable_clauses_of`; formerly `const_evaluatable_predicates_of` in predicates_of.rs).
Fix hunk `@@ -421,7 +421,9 @@ fn const_evaluatable_predicates_of`: replaced `is_const_param_default(self.tcx, uv.def.expect_local())` with `if let Some(local) = uv.def.as_local() && ...`.
In 1.99.1 the helper takes an AliasConstKind and does `as_local()` gracefully (returning false). Reinjected: it now takes `kind.opt_def_id()` of any alias kind and calls `def_id.expect_local()`, so a non-local const (e.g. `std::path::MAIN_SEPARATOR`, a Free alias) ICEs.
