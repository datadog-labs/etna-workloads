# Adapted injection for Deny const auto traits

Fix: https://github.com/rust-lang/rust/commit/231a3a241bbf91771533d3c3b35e868a50ee6d15

File: compiler/rustc_ast_passes/src/ast_validation.rs, `AstValidator::visit_item`, ItemKind::Trait arm.
Removed the call `self.deny_const_auto_traits(*constness);` (and its comment) inside `if *is_auto == IsAuto::Yes`.
Re-expresses fix hunk `@@ -1257,6 +1263,8 @@ impl<'a> Visitor<'a> for AstValidator<'a>` which added that call. The `deny_const_auto_traits` fn (hunk `@@ -820,6 +820,12 @@`) is kept with `#[allow(dead_code)]` so it builds; errors/ftl (in diagnostics.rs now) remain, unused.
