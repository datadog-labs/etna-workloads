# Adapted injection for fix `-Zsanitizer=kcfi` on `#[naked]` functions

Fix: https://github.com/rust-lang/rust/commit/f100767dce1fcc0287047053cc29659ac5321a6b

In 1.99.1 the `is_item_instance` check is gone: the naked check uses `codegen_instance_attrs(instance.def)`, which gives non-naked attrs for shims. To restore the bug I made the checks look at the def_id's attrs, so a ReifyShim of a naked fn is treated as naked.

- compiler/rustc_codegen_ssa/src/mono_item.rs, `MonoItem::define` and `predefine`: now `codegen_fn_attrs(instance.def_id()).flags`. Re-expresses the fix hunk `@@ -41,12 +42,12 @@` (`if is_item_instance && flags.contains(NAKED)` vs. checking naked attrs of any InstanceKind).
- compiler/rustc_codegen_cranelift/src/driver/aot.rs, `codegen_cgu_content`: same change. Re-expresses `@@ -530,8 +530,12 @@`.
