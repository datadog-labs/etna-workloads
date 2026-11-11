# Adapted injection for resolve: Avoid a regression from splitting prelude into two scopes

Fix: https://github.com/rust-lang/rust/commit/8930d3a7504a7bda441782c65a9d6320e7674ba3

# Rationale
File compiler/rustc_resolve/src/ident.rs, function resolve_ident_in_scope_set_inner (ambiguity handling): the `issue_145575_hack` (skip ambiguity errors for ExternPreludeFlags bindings overridden by differing ExternPreludeItems bindings) is replaced with `false`.
Re-expresses fix hunks `@@ -686,7 +694,16 @@` (adds `issue_145575_hack` and `&& !issue_145575_hack`) together with the tracking hunks (`extern_prelude_item_binding`/`extern_prelude_flag_binding`); in 1.99.1 these are folded into one `innermost_results` check, so disabling it restores the parent behaviour (spurious ambiguity error).
