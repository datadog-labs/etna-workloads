# Adapted injection for Fix incorrect `let` to `const` suggestion for pattern bindings

Fix: https://github.com/rust-lang/rust/commit/a687f0b658a47602bec667df9f35f3d100724853

# Rationale
One hunk: compiler/rustc_resolve/src/diagnostics/impls.rs, `into_struct_error`, arm `ResolutionError::AttemptToUseNonConstantValueInConstant`.
The fix (hunk `@@ -984,15 +984,36 @@` in diagnostics.rs, which moved to diagnostics/impls.rs in 1.99.1) added an `is_simple_binding` check
(`after_keyword.is_empty() || after_keyword == "mut"`) and only emitted the `let` -> `const` suggestion when true.
I removed the check, so the suggestion is always emitted again (old behaviour), including for `if let Some(v) = ...` patterns.
