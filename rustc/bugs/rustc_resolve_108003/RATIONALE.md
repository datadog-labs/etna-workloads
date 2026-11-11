# Adapted injection for Fix #107998, avoid ICE when the generic_span is empty

Fix: https://github.com/rust-lang/rust/commit/3180f1c828636a247777d277f10c9695d7141d20

Hunk: compiler/rustc_resolve/src/late/diagnostics.rs, lint closure for SINGLE_USE_LIFETIMES (LifetimeUseSet::One).
Upstream fix hunk `@@ -837,9 +837,17 @@ pub trait LintContext` in rustc_lint/src/context.rs added
`let suggestions = if deletion_span.is_empty() { vec![(use_span, replace_lt)] } else {...}`.
In 1.99.1 the logic moved here, as `let deletion_span = if deletion_span.is_empty() { None } else { Some(deletion_span) };`.
I replaced it with `let deletion_span = Some(deletion_span);`, so an empty deletion span is again suggested for deletion.
