# Adapted injection for Check for missing space between fat arrow and range pattern

Fix: https://github.com/rust-lang/rust/commit/4bfab39f9b466fa89f85c57a42c1e71a99c6aa4e

# Rationale
compiler/rustc_parse/src/parser/pat.rs, `inclusive_range_with_incorrect_end`: removed the
`token::Gt if self.prev_token.kind == token::DotDotEq && no_space => emit_err(InclusiveRangeMatchArrow{..})` arm.
Re-expresses fix hunk `@@ -746,32 +746,38 @@` which added
`token::Gt if no_space => { self.error_inclusive_range_match_arrow(span); }` and the
"If they typed `..=>`, suggest `.. =>`" handling. Without it `74..=>` falls to the generic
"inclusive range with no end" error (the pre-fix behaviour). The other fix hunks (signature refactor, expr.rs call) are pure refactors and were left alone.
