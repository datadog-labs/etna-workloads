# Adapted injection for trigger `unsafe_code` on `global_asm!` invocations

Fix: https://github.com/rust-lang/rust/commit/dc7a01610f2a26dd1e1dadd136b20715909d6b94

Hunk: compiler/rustc_lint/src/builtin.rs, `impl EarlyLintPass for UnsafeCode::check_item`.
Removed the arm `ast::ItemKind::GlobalAsm(..) => self.report_unsafe(cx, it.span, BuiltinUnsafe::GlobalAsm)`.
Re-expresses fix hunk `@@ -393,6 +393,10 @@ impl EarlyLintPass for UnsafeCode` which added that arm. Without it, global_asm! no longer triggers `unsafe_code`.
(Other fix hunks — ftl messages, lints.rs variant, asm.rs span — left as is; they are unused/harmless.)
