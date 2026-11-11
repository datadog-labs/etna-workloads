# Adapted injection for Invalid `?` suggestion on mismatched `Ok(T)`

Fix: https://github.com/rust-lang/rust/commit/6c97f136126557a982990a1d0ef879996b268cba

Hunk: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, `suggest_coercing_result_via_try_operator` (moved from demand.rs in 1.99.1).
Re-expresses fix hunk `@@ -983,6 +983,11 @@ impl FnCtxt` in demand.rs, which added
`let e_ok = args_e.type_at(0); let f_ok = args_f.type_at(0); if !can_eq(f_ok, e_ok) { return false; }`.
I removed the equivalent `let e_ok/f_ok ... can_eq` let-chain conditions, so the `?` suggestion is emitted even when the Ok types differ.
