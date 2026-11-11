# Adapted injection for Ensure we codegen and don't internalize the entrypoint

Fix: https://github.com/rust-lang/rust/commit/c4eb07761643d2fa26d6f609eb23c8d22e14d8eb

Edits re-express fix.diff hunks (is_entrypoint helper left in place, now unused for these sites).
1. compiler/rustc_middle/src/mono.rs `instantiation_mode`: back to `tcx.entry_fn(())` comparison (hunk `@@ -143,10 +143,8 @@` replacing `tcx.is_entrypoint(...)`).
2. compiler/rustc_monomorphize/src/collector.rs `push_extra_entry_roots`: removed the `main_instance` push when `should_codegen_locally` (hunk `@@ -1582,6 +1582,15 @@`).
3. partitioning.rs place_mono_items: LocalCopy only kept as root for LangItem::Start (hunk `@@ -223,11 +223,7 @@`).
4. partitioning.rs `mono_item_visibility`: only `LangItem::Start` is exempt from internalization instead of `is_entrypoint` (hunk `@@ -834,7 +829,7 @@`).
