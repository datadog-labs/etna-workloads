# Adapted injection for Fix value suggestion for array in generic context

Fix: https://github.com/rust-lang/rust/commit/e4c71f1fd8caf703dde7edb75b3cd33585aadddc

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn `ty_kind_suggestion`, `ty::Array` arm.
Re-expresses the fix hunk `@@ -4583,11 +4583,9 @@` which replaced the unconditional `ty::Array(ty, len) => ... len.eval_target_usize(...)` (panics on a generic const like `N`) with a guarded arm `if let Some(len) = len.try_eval_target_usize(..)`.
In 1.99.1 the guard is `len.try_to_target_usize(tcx)`; I removed the guard and unwrap the length with `.expect(..)`, so an unevaluatable length ICEs again. The lib.rs `if_let_guard` hunk is not needed (feature already stable/enabled).
