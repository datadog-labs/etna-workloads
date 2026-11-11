# Adapted injection for Fix bad replacement for unsafe extern block suggestion

Fix: https://github.com/rust-lang/rust/commit/0addda65788642c9967cd151eff953be1ddee32f

Two hunks, both in compiler/rustc_ast_passes/src (files renamed from errors.rs to diagnostics.rs in 1.99.1).

1. ast_validation.rs, visit of foreign item safety check: `block: Some(self.current_extern_span().shrink_to_lo())` -> `Some(self.current_extern_span())`.
   Re-expresses fix hunk `@@ -464,7 +464,7 @@` (`block: self.current_extern_span()` -> `.shrink_to_lo()`).
2. diagnostics.rs, `InvalidSafetyOnExtern.block`: suggestion restored to `code = "", applicability = "maybe-incorrect"` (no verbose style).
   Re-expresses fix hunk in errors.rs `@@ -221,7 +221,7 @@`: `-#[suggestion(code = "", applicability = "maybe-incorrect")]` / `+#[suggestion(code = "unsafe ", applicability = "machine-applicable", style = "verbose")]`.
