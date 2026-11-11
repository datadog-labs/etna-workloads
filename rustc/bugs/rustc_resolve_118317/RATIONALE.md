# Adapted injection for tip for define macro name after `macro_rules!`

Fix: https://github.com/rust-lang/rust/commit/0f14e8ea7421c791690e81e6a484eed81be7e7e1

# Rationale
File: compiler/rustc_resolve/src/diagnostics/impls.rs, fn `unresolved_macro_suggestions` (formerly in diagnostics.rs).
Removed the `if macro_kind == MacroKind::Bang && ident.name == sym::macro_rules { ... err.subdiagnostic(MaybeMissingMacroRulesName{..}); return; }` block.
Re-expresses fix hunk `@@ -1421,14 +1419,21 @@` which added exactly this check (with `MaybeMissingMacroRulesName`) before the Send/Sync derive check. Without it, `macro_rules! {}` loses the "maybe you have forgotten to define a name" note.
