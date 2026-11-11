# Adapted injection for Specify macro is invalid in certain contexts

Fix: https://github.com/rust-lang/rust/commit/287db04636ffefa3fdaa39fe0fdcc3cf75b60444

# Rationale
File: compiler/rustc_parse/src/parser/item.rs, fn `parse_name_and_ty`.
Removed the `if self.token == token::Bang { ... err.subdiagnostic(MacroExpandsToAdtField { adt_ty }) ... }` block (and the now-unused import).
Re-expresses fix hunk `@@ -1691,9 +1698,10 @@ expect_field_ty_separator` / `@@ -1731,7 +1741,7 @@ parse_name_and_ty`, which added `mac_invoc = self.token.kind == token::Not` and
`err.subdiagnostic(MacroExpandsToAdtField { adt_ty })`. Without it, struct/union field macro invocations lose the note "macros cannot expand to struct fields".
