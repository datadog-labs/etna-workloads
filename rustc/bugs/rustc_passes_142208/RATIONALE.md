# Adapted injection for Always consider `const _` items as live for dead code analysis

Fix: https://github.com/rust-lang/rust/commit/33beaba7c8b78e9d4908e98dd1d6b4e15c6ba6f8

Hunk: compiler/rustc_passes/src/dead.rs, check_item (seeding of the dead-code worklist).
Removed the `DefKind::Const { .. }` arm that pushed `const _` items into the worklist as always live.
Re-expresses fix hunk `@@ -793,6 +793,17 @@ fn check_item` (adds `DefKind::Const => { ... ident.name == kw::Underscore ... worklist.push(...) }`).
In 1.99.1 the arm checks `tcx.item_name(..) == kw::Underscore`. The `kw` import is still used elsewhere, so the first fix hunk needs no change.
