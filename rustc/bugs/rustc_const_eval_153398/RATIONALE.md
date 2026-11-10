# Adapted injection for fix ICE in `const_c_variadic` when passing ZSTs

Fix: https://github.com/rust-lang/rust/commit/225b7e001247ff1f6bbfffa884a078a5a3545f8c

# Rationale
File: compiler/rustc_const_eval/src/interpret/call.rs, in the `va_list_arg` branch of `eval_fn_call`'s argument loop (the `ecx.allocate_varargs(...)` call).

The fix's hunk `@@ -480,7 +480,12 @@` made the callee ABIs passed to `allocate_varargs` skip ignored arguments:
`(&mut callee_args_abis).filter(|(_, abi)| !abi.is_ignore())`. Its comment says "Ignored" arguments aren't actually passed, so the callee should also ignore them.

In 1.99.1 the pre-filtering of the caller args (the other hunks) is gone, so I could not just remove that filter. I re-expressed the bug as the same caller/callee mismatch the fix removed. The caller varargs are now filtered with `!abi.is_ignore()`, and the callee ABIs are left unfiltered. A ZST vararg then appears in the callee ABI list but not in the caller list. That trips the asserts in `allocate_varargs`, which is the ICE.
