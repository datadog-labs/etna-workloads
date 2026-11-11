# Adapted injection for fix better_any breakage by making the solver more unsound

Fix: https://github.com/rust-lang/rust/commit/5d9141c6c8640e98856fbe703b9f73204d85ba43

# Hunk: compiler/rustc_next_trait_solver/src/solve/trait_goals.rs, `merge_trait_candidates`
Removed the call `self.unsound_prefer_builtin_dyn_impl(&mut candidates);` after `filter_specialized_impls`.
Re-expresses fix hunk `@@ -1313,6 +1352,7 @@ ... merge_trait_candidates` which added that line. The helper itself (other hunks, already present in 1.99.1) is left in place but is now unused by the caller, so the builtin-dyn-over-impl preference is gone (the pre-fix behaviour).
