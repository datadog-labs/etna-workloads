# Adapted injection for fix query cycle in `coroutine_hidden_types`

Fix: https://github.com/rust-lang/rust/commit/0069ae1a18f28b5fb0fa369a1cb1e933d16fad3c

# compiler/rustc_traits/src/coroutine_witnesses.rs, `compute_assumptions`
Removed the early return
`if tcx.next_trait_solver_globally() || !tcx.sess.opts.unstable_opts.higher_ranked_assumptions { return &ty::List::empty(); }`.
This re-expresses the fix hunk `@@ -47,11 +47,18 @@ coroutine_hidden_types` which added exactly that guard. Without it, higher-ranked assumptions are always computed, causing the query cycle under -Znext-solver.
