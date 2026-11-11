# Adapted injection for Generate error delegation body when delegation is not resolved

Fix: https://github.com/rust-lang/rust/commit/3e717121a1c96ed9717ebac84ecbeac021dabb21

# Re-injection
File: compiler/rustc_ast_lowering/src/delegation/mod.rs (moved from delegation.rs in 1.99.1)

- `lower_delegation`: the resolve failure now passes the ErrorGuaranteed (`Err(err) => self.generate_delegation_error(err, span)`) and no longer passes `delegation`. Re-expresses fix hunk `@@ -96,7 +96,7 @@` (`Err(err) => self.generate_delegation_error(err, span, delegation)`).
- `generate_delegation_error`: signature drops `delegation`; again uses `let ident = Ident::dummy();` and body `ExprKind::Err(err)`, so the user's target block is not lowered. Re-expresses hunks `@@ -404,6 +404,7 @@` and `@@ -418,8 +419,41 @@` (removed `lower_ident(delegation.ident)` and the block with the target expression as a Semi stmt, restoring `Ident::dummy()` + `ExprKind::Err`). Result: unresolved-delegation bodies lose the target expr, so the bug (#144594 / missing errors) returns.
