# Adapted injection for Don't infer attributes of virtual calls based on the function body

Fix: https://github.com/rust-lang/rust/commit/8089fce101f4ac2ed68c8df080c61102b0210429

# Hunk: compiler/rustc_ty_utils/src/abi.rs, `FnAbiParams::for_instance` (determined_fn_def_id)
Re-expresses fix hunk `@@ -648,7 +635,15 @@ fn fn_abi_new_uncached` :
`fn_abi_adjust_for_abi(..., fn_def_id.filter(|_| !is_virtual_call))` (virtual calls must not pass the def id, so `deduced_param_attrs` doesn't infer attrs from the default body).
In 1.99.1 that filter lives in `determined_fn_def_id: (!is_virtual_call && !is_tls_shim_call)`; the bug is restored by dropping `!is_virtual_call`, so virtual calls get readonly etc. deduced from the default method body.
