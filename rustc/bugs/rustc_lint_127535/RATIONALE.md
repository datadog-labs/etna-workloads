# Adapted injection for Fire unsafe_code lint on unsafe extern blocks

Fix: https://github.com/rust-lang/rust/commit/a3ef94e80e0ec7bacd42a70bd8a2203c5cc3fab8

# Rationale
compiler/rustc_lint/src/builtin.rs, `impl EarlyLintPass for UnsafeCode`, `check_item`: removed the arm
`ast::ItemKind::ForeignMod(ForeignMod { safety, .. }) => if let Safety::Unsafe(_) = safety { self.report_unsafe(cx, it.span, BuiltinUnsafe::UnsafeExternBlock) }`.
Re-expresses fix hunk `@@ -326,6 +326,12 @@ impl EarlyLintPass for UnsafeCode` (which added that arm). Parent behaviour: `unsafe extern` blocks don't fire `unsafe_code`.
The lints.rs variant / .ftl message are left in place (unused; harmless dead variant).
