# Adapted injection for More fix on mismatched type suggestion for shorthand fields

Fix: https://github.com/rust-lang/rust/commit/3a4edf0a7f96a413b160b3e9a17e0806abdd4255

Both changes are in compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs. They remove shorthand-field handling from two suggestions.

1. `suggest_pinning`-style Box::pin suggestion (the `_ =>` arm that offers "you need to pin and box this expression").
   - Re-expresses the fix hunk `@@ -628,12 +640,20 @@`, which added `let prefix = ... maybe_get_struct_pattern_shorthand_field(expr) ... format!("{prefix}Box::pin(")`.
   - Reverted to the plain `"Box::pin("`, so a shorthand field gets `Demo { Box::pin(a) }`.
2. `suggest_into`-style `.into()` suggestion.
   - Re-expresses the fix hunk `@@ -1214,7 +1234,7 @@` / `@@ -1222,6 +1242,9 @@`: `let mut sugg` plus `sugg.insert(0, (.., format!("{}: ", name)))`.
   - Removed the insert and went back to `let sugg`.

I did not re-express the `prefix_wrap` hunks for `.as_ref()`, `.as_deref()` and `.map(|x| x.as_str())`, or the `errors.rs` hunk. They would also have needed `SuggestConvertViaMethod.sugg` changed back to `&'static str`.
