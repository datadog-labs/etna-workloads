# Adapted injection for Suggest similar keyword when visibility is not followed by an item

Fix: https://github.com/rust-lang/rust/commit/7f53271474ca601c3f3f2b1a1c2b9a6dfd821d42

compiler/rustc_parse/src/parser/item.rs, parse_item_common_ (the "failed to parse an item" path): re-expresses the single hunk `@@ -192,7 +192,22 @@`. The fix replaced `emit_err(VisibilityNotFollowedByItem)` with `create_err` plus a `MisspelledKw` subdiagnostic (find_similar over used_keywords). Reinjected: removed the subdiagnostic and went back to a plain `emit_err`, so no "similar keyword" suggestion is given.
