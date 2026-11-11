# Adapted injection for Check type_const type is ConstParamTy_ and that RHS matches it

Fix: https://github.com/rust-lang/rust/commit/9ba89327df659b47dadddfcb662fa82ff04ec616

# Rationale
One hunk: compiler/rustc_hir_analysis/src/check/wfcheck.rs, `check_type_const`.
Re-expresses fix.diff hunk `@@ -1230,16 +1233,33 @@ check_static_item` (`check_const_item_rhs` -> `check_type_const`), which added
(a) the `register_bound(item_ty: ConstParamTy_)` obligation and (b) the
`ConstArgHasType(norm_ct, item_ty)` obligation for the RHS. Both are removed, restoring the
parent behaviour (type_const type not checked as ConstParamTy_, RHS not checked against it).
The `item_ty` param is renamed `_item_ty` (unused). Other fix hunks (hir.rs, call sites, error reporting) already exist/are harmless in 1.99.1.
