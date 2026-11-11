# Adapted injection for Don't ICE if we collect no RPITITs unless there are no unification errors

Fix: https://github.com/rust-lang/rust/commit/07bd05e036da845d0b6cad8c370f434b2ea3babb

# Rationale
File: compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, fn `collect_return_position_impl_trait_in_trait_tys`.

Fix hunk 2 (`@@ -646,6 +638,13 @@`) moved the "expect >0 RPITITs" check to after the unification-error early return. Fix hunk 1 (`@@ -520,14 +520,6 @@`) removed it from right after `.fold_with(&mut collector)`. I reversed both: removed the late `delayed_bug` check (1.99 form of the late check) and re-added the check before `ocx.normalize(... unnormalized_trait_sig)`, as in the parent commit.

Adaptation: the check is now a hard `bug!` (parent used `debug_assert_ne!`, which is not active in release builds), and it uses `has_non_region_error()` instead of `references_error()`. In 1.99 a `'{region error}` counts as `references_error`, which would hide the ICE; in 2024 it did not.
