# Adapted injection for Emit a single error when importing a path with `_`

Fix: https://github.com/rust-lang/rust/commit/d82fb1e72df42c8a18e354f6a9cc778d19055a10

# Rationale
File: compiler/rustc_resolve/src/diagnostics/impls.rs, fn `throw_unresolved_import_error` (moved from imports.rs in 1.99.1).
Removed the filter that drops resolve errors whose `err.segment` is `kw::Underscore` (and the delayed_bug when errors become empty).
Re-expresses fix hunk `@@ -688,14 +690,19 @@` in imports.rs: the added
`errors.retain(|(_import, err)| err.segment != Some(kw::Underscore))` and the `delayed_bug("expected a parse or \"`_` can't be an identifier\" error")`.
Result: `use _;` / `use ::_;` emit both the "expected identifier" error and a spurious E0432 unresolved import.
The other hunks (is_empty guard, const move) are not behavioural and weren't touched.
