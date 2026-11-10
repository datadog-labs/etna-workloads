# Adapted injection for Don't check for alias bounds in liveness when aliases have escaping bound vars

Fix: https://github.com/rust-lang/rust/commit/4d5d763e051fcbaf7b68d2b2c445d1cce21c35b4

# Rationale

The fix hunk (`@@ -49,6 +51,12 @@` in compiler/rustc_infer/src/infer/outlives/for_liveness.rs, adding
`if ty.has_escaping_bound_vars() { return ty.super_visit_with(self); }`) stopped the liveness visitor from
trusting alias bounds on aliases with escaping bound vars. In 1.99.1 that file is gone. The logic now lives in
compiler/rustc_trait_selection/src/traits/outlives_for_liveness.rs, and it handles such aliases differently:
bounds yield all args known to outlive the bound region.

Changed hunk: `live_args_for_alias_from_outlives_bounds`. Per outlives bound, the live args are now only the
bound region itself rather than every arg known to outlive it. This restores the old "use the alias's outlived
region only" behaviour, so `T::Gat<'a,'_,'static>: 'c` (c='static) no longer keeps `'a` live and E0716 is lost
in escaping-bounds-2.rs. This is not a literal reversal: it applies to all aliases, not only those with escaping bound vars.
