# Adapted injection for Do not project when there are unconstrained impl params

Fix: https://github.com/rust-lang/rust/commit/2d602ea7931ca6988a34567d9255a10c09d0e17e

# Rationale
Only file changed: compiler/rustc_trait_selection/src/traits/specialize/specialization_graph.rs, fn `assoc_def`.
Removed both calls to `tcx.ensure_result().enforce_impl_non_lifetime_params_are_constrained(impl_def_id)?`
(the early-return path for an impl item, and the ancestors/leaf_def path). This re-expresses the fix hunks
`@@ -376,6 +376,12 @@ pub(crate) fn assoc_def(` ("Ensure that the impl is constrained, otherwise projection may give us bad unconstrained infer vars") and
`@@ -391,6 +397,14 @@`. Without them projection proceeds through impls with unconstrained params.
The query itself is still used by check_impl_wf, so everything builds.
