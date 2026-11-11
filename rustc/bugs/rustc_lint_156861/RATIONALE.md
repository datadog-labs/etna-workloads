# Adapted injection for Suppress garbled suggestions from strict provenance lints in macros

Fix: https://github.com/rust-lang/rust/commit/ccac0d974451a0888f3ca616fd622c6c41aac96c

# Rationale
The lint moved from rustc_hir_typeck/cast.rs to compiler/rustc_lint/src/implicit_provenance_casts.rs (`lint_ptr2int`, `lint_int2ptr`); the `Option` sugg fields already exist in diagnostics.rs.
- `lint_ptr2int`: removed `expr.span.can_be_used_for_suggestions().then(|| ...)` guard, so the suggestion is always `Some(..)`. Re-expresses fix hunk `@@ -1134,28 +1134,30 @@ lossy_provenance_ptr2int_lint` (`let sugg = self.span.can_be_used_for_suggestions().then(|| {`).
- `lint_int2ptr`: same, `Some(Int2PtrSuggestion{..})` always. Re-expresses hunk `@@ -1167,10 +1169,12 @@ fuzzy_provenance_int2ptr_lint`.
Effect: suggestions with macro-expanded spans are emitted again (garbled).
