# Adapted injection for Deny final not followed by item

Fix: https://github.com/rust-lang/rust/commit/59781157a7d45720399076311095732ecfd79606

# Rationale
File compiler/rustc_parse/src/parser/item.rs, fn parse_item_`...` (the fallback in parse_item_common that emits DefaultNotFollowedByItem):
removed the branch `else if let Defaultness::Final(span) = def { emit_err(FinalNotFollowedByItem { span }) }`.
Re-expresses fix hunk `@@ -197,6 +197,8 @@ impl<'a> Parser<'a>` which added that `else if let Defaultness::Final(span) = def` arm.
The diagnostic struct (diagnostics.rs, formerly errors.rs) is left in place (now unused -> dead_code warning only).
