# Adapted injection for Add test and comment for https://github.com/rust-lang/rust/issues/158656

Fix: https://github.com/rust-lang/rust/commit/50181ca249450bd2cf682b0f384e40d090165870

# Rationale
The fix diff only adds a comment (plus test) at `@@ -772,6 +772,10 @@` in `SelectionContext::evaluate_predicate_recursively` (compiler/rustc_trait_selection/src/traits/select/mod.rs), on the arm `ty::PredicateKind::DynCompatible(trait_def_id)`. The comment says such obligations are rare but possible during evaluation; the underlying bug (#158656) is that this arm did not handle them. I replaced the arm (is_dyn_compatible -> Ok/Err) with a `bug!` so the old-solver ICEs on the nested-RPIT `dyn` case.
