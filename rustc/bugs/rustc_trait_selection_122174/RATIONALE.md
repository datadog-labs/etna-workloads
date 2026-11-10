# Adapted injection for diagnostics: suggest `Clone` bounds when noop `clone()`

Fix: https://github.com/rust-lang/rust/commit/c2cc90402b6a896c3273a57e506d6c02a1ec6038

File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn suggest_clone_for_ref (file moved from traits/error_reporting/suggestions.rs).
Hunk 1 (@@ -987,10 +987,6 / -998,6 +994,39): fix replaced the `let Node::Expr(Path) = arg_node else { return false }` check with an `existing_clone_call` match that also accepts `.clone()` MethodCalls. Re-injected the old Path-only check, so a `thing.clone()` argument returns false.
Hunk 2 (@@ -1015,12 +1044,23): fix added `if let Some(existing_clone_call) ... span_note("this `clone()` copies the reference...")` else the suggestion. Restored the unconditional "consider using clone here" suggestion.
