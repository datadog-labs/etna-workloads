# Adapted injection for Extend format arg help for simple tuple index access expression

Fix: https://github.com/rust-lang/rust/commit/52a112503674f8492ecfcf2a50d989e9ca4e3cd6

# Rationale
File: compiler/rustc_parse_format/src/lib.rs, fn `suggest_positional_arg_instead_of_captured_arg`.
Re-expresses fix hunk `@@ -907,25 +907,47 @@ impl<'a> Parser<'a>`: the fix added an `ArgumentIs(_) =>` arm to the `match field.position`
(description "tuple index access isn't supported", Suggestion::UsePositional). I removed that arm (and reverted the comment
to "`foo.bar` field access"), so `{x.0}` no longer gets the dedicated error/suggestion.
