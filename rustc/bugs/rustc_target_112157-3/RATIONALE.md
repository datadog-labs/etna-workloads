# Adapted injection for rustc_target: Add alignment to indirectly-passed by-value types, correcting the alignment of `byval` on x86 in the process.

Fix: https://github.com/rust-lang/rust/commit/0becc89d4a75d14571b02fb34ec1e3a45c9fb9dc

In compiler/rustc_target/src/callconv/mod.rs (the file was moved from abi/call/mod.rs in 1.99.1; `make_indirect_byval` is now `pass_by_stack_offset`):

1. `ArgAbi::indirect_pass_mode`: re-comments out `attrs.pointee_align = Some(layout.align.abi);` with the old FIXME(eddyb) comment. Re-expresses hunk `@@ -494,9 +494,7 @@` (`-// attrs.pointee_align = Some(layout.align.abi);` / `+attrs.pointee_align = Some(layout.align.abi);`).
2. `ArgAbi::pass_by_stack_offset`: the `byval_align` is no longer applied to `attrs.pointee_align` (the `if let Some(byval_align)` block is removed). Re-expresses hunk `@@ -513,11 +511,19 @@` (`make_indirect_byval(byval_align)` setting `attrs.pointee_align = Some(byval_align)`). This drops the x86-32 byval alignment.
