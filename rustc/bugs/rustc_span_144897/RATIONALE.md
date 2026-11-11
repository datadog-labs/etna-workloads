# Adapted injection for print raw lifetime idents with `r#`

Fix: https://github.com/rust-lang/rust/commit/1e5b5ba1e732d557f00a3cd79150990370c7db0a

# Rationale
compiler/rustc_span/src/symbol.rs, `Ident::guess_print_mode`: no longer returns `IdentPrintMode::RawLifetime` for raw-lifetime idents (only checks `is_raw_guess`).
This re-expresses the fix hunks around `impl fmt::Display for Ident` (`@@ -2533,10 +2533,16 @@`, `IdentPrinter::new(self.name, self.guess_print_mode(), None)`) and the added `is_raw_lifetime_guess`/`guess_print_mode` (`@@ -3020,6 +3045,25 @@`): before the fix, Display only guessed `r#` for plain idents, so `'r#async` in suggestions printed as `'async`.
