# Adapted injection for Fix unused lint error in macro

Fix: https://github.com/rust-lang/rust/commit/87f75df0b80b038daf307f56e0dde73b8514d195

# Rationale
File: compiler/rustc_lint/src/unused/must_use.rs, fn emit_must_use_path (arm `MustUsePath::Def`; moved from unused.rs in 1.99.1).
Re-expresses both hunks of fix.diff (`@@ -539,10 +539,19 @@` and `@@ -551,11 +560,13 @@`): the fix added `is_redundant_let_ignore` and a separate `suggestion_span` (the unexpanded `*span` when preceded by `let _ =`). I removed that, so the suggestion uses the ancestor-not-from-macro span again (`let span = span.find_ancestor_not_from_macro().unwrap_or(*span)`), giving a wrong suggestion span for `let _ = foo!();`.
