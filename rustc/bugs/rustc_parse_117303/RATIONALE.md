# Adapted injection for Suggest `=>` --> `>=` in conditions

Fix: https://github.com/rust-lang/rust/commit/97cf1c87bd98c13f4de91f7afbc971dba829ac92

One hunk: compiler/rustc_parse/src/parser/diagnostics.rs, `unexpected_try_recover`/expected-token error path (fn building `err` after `label_expected_raw_ref`).
Removed the block "Look for usages of '=>' where '>=' was probably intended" (`self.token == token::FatArrow && expected has Operator|Le ...` -> suggest `>=`).
Re-expresses fix hunk `@@ -610,6 +610,26 @@ impl<'a> Parser<'a>` in diagnostics.rs, which added that block. The expr.rs hunks (if-condition recovery) still exist in 1.99.1 and were left intact; the removal is enough to fail eq-gt-to-gt-eq.rs.
