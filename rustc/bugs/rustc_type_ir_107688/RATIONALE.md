# Adapted injection for ReErased regions are local

Fix: https://github.com/rust-lang/rust/commit/9d110847ab7f6aef56a8cd20cb6cea4fbcc51cd9

# flags.rs: TypeFlags::HAS_FREE_LOCAL_NAMES
Fix hunk `@@ -220,7 +220,8 @@ bitflags!` in compiler/rustc_type_ir/src/lib.rs added `| TypeFlags::HAS_RE_ERASED.bits` to HAS_FREE_LOCAL_NAMES (ReErased regions are local).
In 1.99.1 the flag lives in compiler/rustc_type_ir/src/flags.rs; I removed `| TypeFlags::HAS_RE_ERASED.bits()` from HAS_FREE_LOCAL_NAMES, restoring the buggy behaviour.
