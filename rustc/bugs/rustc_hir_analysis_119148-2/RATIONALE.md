# Adapted injection for Provide better suggestions when encountering a bare trait as a type

Fix: https://github.com/rust-lang/rust/commit/048750077676190a0733112d8f700e76a0553f60

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs, function `prohibit_or_lint_bare_trait_object_ty` (2021 error path).
Removed the `&& !self.maybe_suggest_impl_trait(span, hir_id, hir_bounds, &mut diag)` condition.
Re-expresses fix hunk `@@ -98,7 +187,9 @@ ... maybe_lint_bare_trait`, which added
`&& !self.maybe_lint_impl_trait(self_ty, &mut diag)` so the generic/impl/&dyn/Box<dyn> suggestions are emitted.
Without it (parent behaviour) only the plain "use `dyn`" suggestion appears for bare traits in fn params/returns.
