# Adapted injection for Do not ICE when we have fn pointer Fn obligations with bound vars in the self type

Fix: https://github.com/rust-lang/rust/commit/4fe232b27770f3e568fa4fa676f8bbd1ff595a6c

# Rationale
File: compiler/rustc_trait_selection/src/traits/select/confirmation.rs, fn `confirm_fn_pointer_candidate`.

Fix hunk `@@ -601,10 +601,18 @@ ... confirm_fn_pointer_candidate`: replaced
`shallow_resolve(obligation.self_ty().no_bound_vars()).expect("fn pointer should not capture bound vars from predicate")`
with a `let Some(..) else { return Err(SelectionError::Unimplemented) }`.

In 1.99.1 the code was restructured (self type taken from the placeholder predicate). I restored the old behaviour:
self_ty is computed from `obligation.self_ty().no_bound_vars().expect("fn pointer should not capture bound vars from predicate")`,
so `for<'w> fn(&'w ()): Fn(&'w ())` ICEs again instead of being handled.
