# Adapted injection for parser: more friendly hints for handling `async move` in the 2015 edition

Fix: https://github.com/rust-lang/rust/commit/8e32dade71ad57978786537ec41c13222fd14611

# Rationale
File compiler/rustc_parse/src/parser/diagnostics.rs, fn `expected_one_of_not_found` (the error-recovery path).
Fix hunk `@@ -573,6 +574,12 @@ impl<'a> Parser<'a>` added `if self.token.is_keyword(kw::Move) && self.prev_token.is_keyword(kw::Async) { ... AsyncMoveBlockIn2015 }`.
In 1.99.1 this check was merged with the `async use` case; I restricted the condition to `kw::Use` only and removed the `Move` branch, so `async move {}` in 2015 again produces the generic "expected one of ..." error. The messages.ftl/errors.rs hunks (new diagnostic) still exist in 1.99.1 and are left in place (the struct is now unused in the parser's use list only).
