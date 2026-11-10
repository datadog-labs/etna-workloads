# Adapted injection for the `#[track_caller]` shim should not inherit `#[no_mangle]`

Fix: https://github.com/rust-lang/rust/commit/20d62469ba7f71aab3c0fc4884cde08f7acc5b1c

# Hunk
File: compiler/rustc_middle/src/middle/codegen_fn_attrs.rs, fn `codegen_instance_attrs`.
Re-expresses fix hunk `@@ -23,6 +25,28 @@`: the block for `InstanceKind::ReifyShim` + TRACK_CALLER that did
`if attrs.flags.contains(NO_MANGLE) { attrs.to_mut().flags.remove(NO_MANGLE); }`. I removed that NO_MANGLE removal,
so the reify shim inherits `#[no_mangle]` and gets the same symbol as the function ("symbol `foo` is already defined").
