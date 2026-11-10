# Adapted injection for Do not allow safe usafe on static and fn items

Fix: https://github.com/rust-lang/rust/commit/22831ed1170a3f709588dc562eba6b262f79cf4e

# Rationale
File: compiler/rustc_ast_passes/src/ast_validation.rs, fn `check_item_safety`.
Re-expresses fix hunk `@@ -456,15 +456,29 @@ impl<'a> AstValidator<'a>` (the new `None => { if matches!(safety, Safety::Safe(_)) { emit_err(InvalidSafetyOnItem { span }) } }` arm).
The arm is emptied (`None => {}`), so `safe fn` / `safe static` outside `extern` blocks are no longer rejected (parent behaviour, issue #126749).
