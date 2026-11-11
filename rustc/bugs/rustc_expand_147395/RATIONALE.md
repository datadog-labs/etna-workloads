# Adapted injection for Improve diagnostics: replace 'non-inline module' with 'file module' and update note/help messages

Fix: https://github.com/rust-lang/rust/commit/02126adc1b8d0b61ddaec2adb9c0d2c9dddcd493

Edited compiler/rustc_expand/src/diagnostics.rs (messages are inline in 1.99.1, not in messages.ftl).
- `ModuleInBlock` diag: restored "non-inline module" wording and removed the struct-level `#[note(...)]`
  (fix hunks `@@ -118,8 +118,9 @@ expand_module_in_block` in messages.ftl and `@@ -265,6 +265,7 @@` in errors.rs adding `#[note]`).
- `ModuleInBlockName`: `#[help(...)]` back to `#[note(...)]` (fix hunk `-#[note(expand_note)] +#[help(expand_help)]`).
