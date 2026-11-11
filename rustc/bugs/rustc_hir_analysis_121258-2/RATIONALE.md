# Adapted injection for Reject early-bound params in the type of assoc const bindings

Fix: https://github.com/rust-lang/rust/commit/d26c5723e793c793c152fffaadc3dc7a45eac29e

# Hunk: compiler/rustc_hir_analysis/src/hir_ty_lowering/bounds.rs, `check_assoc_const_binding_type`
The fix (`@@ -438,14 +439,8 @@ bounds.rs`) introduced `check_assoc_const_binding_type`, which rejects early-bound params in the type of assoc const bindings (`if !ty.has_param() { return ty; }` then collects params and emits ParamInTyOfAssocConstBinding). Before the fix, no check existed and the type was fed as-is.
In 1.99.1 the function exists with the guard `!ty.has_param() && !ty.has_escaping_bound_vars()`; I changed it to `!ty.has_escaping_bound_vars()`, so types containing only early-bound params skip the check and are accepted again (the old behaviour). Escaping-bound-var rejection (a later addition) is kept.
