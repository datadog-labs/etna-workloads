# Adapted injection for Do not mix normalized and unnormalized caller bounds when constructing param-env for receiver_is_dispatchable

Fix: https://github.com/rust-lang/rust/commit/4f2baaa9c6b75d4267eea9e1096339d56d380615

# Rationale
File: compiler/rustc_trait_selection/src/traits/dyn_compatibility.rs, fn receiver_is_dispatchable.
Fix hunk `@@ -583,27 +583,36 @@ fn receiver_is_dispatchable`: replaced `let param_env = tcx.param_env(method.def_id);` + chaining caller_bounds
with building from `tcx.predicates_of(method.def_id).instantiate_identity(..)` (unnormalized).
In 1.99.1 the unnormalized start is `tcx.clauses_of(method.def_id).instantiate_identity(tcx).clauses...`; I reverted it to
`tcx.param_env(method.def_id).caller_bounds().iter().collect()`, so normalized clauses are mixed with the unnormalized Unsize/Trait/MetaSized clauses again.
