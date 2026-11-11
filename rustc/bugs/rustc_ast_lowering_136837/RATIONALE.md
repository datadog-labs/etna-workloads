# Adapted injection for Don't ICE when failing to lower contracts for associated impl items

Fix: https://github.com/rust-lang/rust/commit/4f18560d0600ae235289a6c4c745c9c4c300a602

# Rationale
File compiler/rustc_ast_lowering/src/item.rs, `lower_impl_item` (AssocItemKind::Fn arm): the call to
`lower_maybe_coroutine_body` now passes `None` instead of `contract.as_deref()`.
Re-expresses fix hunk `@@ -931,7 +905,7 @@ ... AssocItemKind::Fn(box Fn { sig, generics, body, contract, .. })` /
`+ contract.as_deref(),`: before the fix, impl-item fns did not thread their contract into body lowering,
so contracts on associated impl items failed to lower (ICE). Other hunks (the contract_ensures refactor) already exist in 1.99.1 in a different form (lower_contract) and were left alone.
