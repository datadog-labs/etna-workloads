# Adapted injection for Be a bit more careful around exotic cycles in in the inliner

Fix: https://github.com/rust-lang/rust/commit/3b9c16bc0e90e57ed4ff548a50a577ea4dd7a50c

Hunk changed: compiler/rustc_mir_transform/src/inline/cycle.rs, `process`.
Re-expresses fix hunk `@@ -101,10 +104,17 @@` (`let callee_reaches_root = if let Some(&c) = seen.get(&callee) { c } else {...}`):
the fix propagates the cached "reaches root" result for already-seen callees so all involved callers get marked.
Buggy version: an already-seen callee contributes `false` (like the old `if seen.insert(callee) {..}` which ignored seen callees), so exotic double cycles miss involved functions.
