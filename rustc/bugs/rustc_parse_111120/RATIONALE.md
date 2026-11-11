# Adapted injection for code refactor and fix wrong suggestion

Fix: https://github.com/rust-lang/rust/commit/5e94b5faf1f0812207a9128e2754bd146210b16e

# Rationale
- diagnostics.rs, `expected_ident_found`: added `self.suggest_add_missing_let_for_stmt(&mut err);` just before the `if let Some(recovered_ident) ... && recover` block. Re-expresses the fix hunk `@@ -399,29 +399,6 @@` which removed the inline `a: Ty = 1` -> `let` suggestion from this function (the buggy parent emitted it for any expected-ident error, e.g. struct field `: u8 =,`). The helper already exists in 1.99.1 (the fix's second diagnostics hunk).
- stmt.rs, `parse_stmt_without_recovery`: removed the `self.suggest_add_missing_let_for_stmt(&mut err)` call in the `Err` arm, re-expressing `@@ -99,7 +99,13 @@` (`ForceCollect::No => match ... Err(mut err) => { self.suggest_add_missing_let_for_stmt(...) }`), which the parent lacked.
