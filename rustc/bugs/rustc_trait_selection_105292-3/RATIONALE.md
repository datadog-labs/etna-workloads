# Adapted injection for Change commit_if_ok to probe

Fix: https://github.com/rust-lang/rust/commit/abe040d876f697ef86b1ad395caf68c03ecbf046

# Rationale
File: compiler/rustc_trait_selection/src/traits/const_evaluatable.rs, fn satisfied_from_param_env, Visitor::visit_const.
Fix hunk `@@ -173,16 +173,11 @@ fn satisfied_from_param_env`: replaced `self.infcx.commit_if_ok(|_| {... Ok(())/Err(())})` with `self.infcx.probe(|_| {...is_ok() && ...})`.
In 1.99.1 the code is already a `probe` (with ObligationCtxt::new and single_match logic); I re-introduced `commit_if_ok`, so a successful candidate match leaks its inference-variable constraints (issue 105037) instead of being rolled back.
