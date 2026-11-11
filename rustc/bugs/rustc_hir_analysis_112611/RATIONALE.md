# Adapted injection for Error on unconstrained lifetime in RPITIT

Fix: https://github.com/rust-lang/rust/commit/bc78d0cbf1efb76fa6d7c80bb029a4b6d9af92c3

# Rationale
Only one hunk is re-expressed: compiler/rustc_hir_analysis/src/impl_wf_check.rs, `enforce_impl_params_are_constrained`.

Fix hunk `@@ -106,10 +106,23 @@ fn enforce_impl_params_are_constrained`: the fix added an `ty::AssocKind::Fn` arm that
collects params from the RPITIT trait-ty table so lifetimes in return-position impl Trait in trait
are treated as appearing in associated types (E0207 for unconstrained lifetimes). Before the fix
(`ty::AssocKind::Fn | Const => Vec::new()`), such lifetimes were ignored.
In 1.99.1 RPITITs are always lowered to synthesized impl assoc types, so the equivalent is the Type arm;
I skip those (`!item.is_impl_trait_in_trait()`), restoring the old behaviour of not counting RPITIT lifetimes.
The compare_impl_item.rs hunks (structural-compat refactor) are already present in 1.99.1 and were not touched.
