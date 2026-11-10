# Adapted injection for Avoid crashing on variadic functions when producing arg-mismatch errors

Fix: https://github.com/rust-lang/rust/commit/45eceb2c576d20dd43c22ae4b591a4f1e9d1db56

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/checks.rs, fn `get_hir_param_info` (body-params branch `(Some(body), None)`).
The fix hunks (@@ -2651,7 +2651,16 @@: `if fn_decl.c_variadic { params.pop(); }` and replacing `zip_eq` with a length-checked zip) became, in 1.99.1, the `params.len() - sig.decl.c_variadic()` trim. I removed that trim (body params now include the `...` param) and use `zip_eq`, so the length mismatch panics for variadic fns (the original crash).
