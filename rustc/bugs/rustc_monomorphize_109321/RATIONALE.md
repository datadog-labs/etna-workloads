# Adapted injection for Erase impl regions when checking for impossible to eagerly monomorphize items

Fix: https://github.com/rust-lang/rust/commit/e3b0a728b4aa886fcb451b2a3bd7662942a5acaa

# Rationale
File compiler/rustc_monomorphize/src/collector.rs, fn create_mono_items_for_default_impls.
Fix hunk `@@ -1326,27 +1326,40 @@`: the fix passes `impl_substs` (lifetimes -> ReErased) to
`subst_and_check_impossible_predicates((item.owner_id.to_def_id(), impl_substs))`, replacing
`InternalSubsts::identity_for_item(...)`. I re-introduce the identity args (late-bound/early-bound impl regions
left as params, not erased) for the impossible-clauses check by shadowing `impl_args` with
`GenericArgs::identity_for_item` after the trait_ref is computed.
