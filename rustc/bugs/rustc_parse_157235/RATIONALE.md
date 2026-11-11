# Adapted injection for fix

Fix: https://github.com/rust-lang/rust/commit/381cea98cbe6e7e78668b812415c796149d12b51

Files moved: errors.rs is now compiler/rustc_parse/src/diagnostics.rs.
1. diagnostics.rs UseDoubleColonSuggestion / UseRegularStructSuggestion: restored trailing ':' in messages
   (fix hunk `@@ -4642,7 +4642,7 @@` and `@@ -4653,13 +4653,13 @@`, "use a double colon" -> "use a double colon:").
   The brace-spacing part (" {{ ") was not reverted.
2. parser/item.rs parse_tuple_struct_body map_err (fix hunk `@@ -2163,8 +2163,10 @@`): the double-colon suggestion
   is again emitted only inside `if encountered_colon` instead of `if self.token == token::Colon`.
   So `struct Foo(std::string:String)` gets no double-colon help.
