# Adapted injection for Don't normalize higher-ranked assumptions if they're not used

Fix: https://github.com/rust-lang/rust/commit/e3f104608c0ad26e80b1ebedef2ab8a748189e52

# Rationale
Fix hunk: `@@ -423,19 +423,24 @@` in select/confirmation.rs added `if ...unstable_opts.higher_ranked_assumptions { for assumption in constituents.assumptions { normalize_with_depth_to(...) } }`.

In 1.99.1 that guard already exists in confirmation.rs, but `compute_assumptions` (compiler/rustc_traits/src/coroutine_witnesses.rs) additionally returns an empty list unless the flag is set, so removing the guard alone changes nothing.

Changes (both re-express "normalize/register the higher-ranked assumptions even without -Zhigher-ranked-assumptions"):
1. compiler/rustc_trait_selection/src/traits/select/confirmation.rs, `confirm_auto_impl_candidate`-area: replaced `if ...higher_ranked_assumptions {` with a bare block, i.e. the pre-fix unconditional normalization loop.
2. compiler/rustc_traits/src/coroutine_witnesses.rs, `compute_assumptions`: dropped `|| !...higher_ranked_assumptions` from the early return, so assumptions are computed without the flag and the unconditional loop in (1) has something to normalize.
