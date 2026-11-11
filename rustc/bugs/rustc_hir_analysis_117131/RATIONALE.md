# Adapted injection for Add all RPITITs when augmenting param-env with GAT bounds in check_type_bounds

Fix: https://github.com/rust-lang/rust/commit/dd571e472ac46f1abda13f02e49085e458d26614

# Rationale
File compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, fn `param_env_with_gat_bounds`.
Re-expresses the fix hunk `@@ -2296,84 +2295,111 @@ fn param_env_with_gat_bounds`, which added
`let impl_tys_to_install = match impl_ty.opt_rpitit_info {... associated_types_for_impl_traits_in_associated_fn ...}`
so all RPITITs of the same fn body get projection predicates. Buggy version: `let impl_tys_to_install = vec![impl_ty];`
(only the single item is installed). The loop body is unchanged (the signature refactor hunks are not needed).
