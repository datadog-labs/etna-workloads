# Adapted injection for Do not allow attributes on struct field rest patterns

Fix: https://github.com/rust-lang/rust/commit/3f09a2054921708ac8288ac9912885dbe66682ec

# Rationale
File compiler/rustc_parse/src/parser/pat.rs, fn `parse_pat_fields`: moved the `parse_outer_attributes()` + `let lo = self.token.span;` block from after the `..`/`...`/`_` rest handling (just before `collect_tokens`/`parse_pat_field`) back to the top of the `while` loop, before the comma check. This reverses fix hunks `@@ -1472,17 +1472,6 @@` (removal of the block at loop top) and `@@ -1585,6 +1574,17 @@` (addition before `let field = self.collect_tokens(...)`). Attributes before `..` are again parsed and silently dropped.
