# Adapted injection for Do not deduce parameter attributes during CTFE

Fix: https://github.com/rust-lang/rust/commit/55509a9fe4a6500060594f2008ef62e1d02c35f5

# Rationale
1.99.1 already contains the `fn_abi_of_instance_no_deduced_attrs` query. CTFE reaches it only through the wrapper `InterpCx::fn_abi_of_instance_no_deduced_attrs` in `compiler/rustc_const_eval/src/interpret/eval_context.rs`.

Hunk: that wrapper now calls `FnAbiOf::fn_abi_of_instance` (the deduced-attrs ABI) instead of `FnAbiOf::fn_abi_of_instance_no_deduced_attrs`.

This re-expresses the fix hunk `@@ eval_context.rs`:
`-        FnAbiOf::fn_abi_of_instance(self, instance, extra_args)`
`+        FnAbiOf::fn_abi_of_instance_no_deduced_attrs(self, instance, extra_args)`

All three CTFE call sites (call.rs x2, step.rs) go through this wrapper. So CTFE once again looks at function bodies to deduce ReadOnly/CapturesNone, which causes the query cycle.
