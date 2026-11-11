# Adapted injection for Determine `self_ty` with expected `ty`

Fix: https://github.com/rust-lang/rust/commit/2f65aac667302849407fe677cc34078300b57eee

# Hunk: compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, `report_trait_method_mismatch`
The E0053 self-receiver suggestion calls `get_self_string(ty, |ty| ty == impl_trait_ref.self_ty())`
(1.99.1 refactored `ExplicitSelf::determine` into `get_self_string`). Re-expresses fix hunk
`@@ -901,7 +901,7 @@ fn report_trait_method_mismatch`:
`-determine(ty, |_| ty == impl_trait_ref.self_ty())` / `+determine(ty, |ty| ty == ...)`.
Bug restored: closure ignores its argument (`|_|`) and compares the whole receiver type, so
`&mut Foo` / `Foo` are never recognised as Self-based, giving `self: &Bar` instead of `&self`.
