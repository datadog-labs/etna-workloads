# Adapted injection for Don't eagerly convert principal to string

Fix: https://github.com/rust-lang/rust/commit/eebd31c1875677bf1f4d7c43801f6cedd57c0ea2

Re-injects eager stringification of the principal.
- compiler/rustc_lint/src/diagnostics.rs, struct SupertraitAsDerefTarget: `target_principal` changed from PolyExistentialTraitRef<'a> back to `String`. Re-expresses fix hunk `@@ -556,8 +556,7 @@ ... pub target_principal: PolyExistentialTraitRef<'a>` (was `String`).
- compiler/rustc_lint/src/deref_into_dyn_supertrait.rs, lint_item: `target_principal: target_principal.to_string()`. Re-expresses hunk `@@ -78,7 +78,7 @@` (`-target_principal: target_principal.to_string(), +target_principal,`).
The sty.rs IntoDiagnosticArg impl already exists generically in 1.99.1 (ir_print.rs), so is unchanged.
