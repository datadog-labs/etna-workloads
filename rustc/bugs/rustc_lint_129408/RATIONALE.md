# Adapted injection for Fix handling of macro arguments within the `dropping_copy_types lint

Fix: https://github.com/rust-lang/rust/commit/6a878a9630945cd6a61ad5e83ec5c543c6e8dab7

# Rationale
File: compiler/rustc_lint/src/drop_forget_useless.rs, closure `let_underscore_ignore_sugg` in `DropForgetUseless::check_expr`.
Re-expresses fix hunk `@@ -151,10 +151,11 @@`: the fix added `&& let Some(arg_span) = arg.span.find_ancestor_inside(expr.span)` (in 1.99.1: `find_ancestor_inside_same_ctxt`) and used `arg_span` for start_span/end_span. I removed that check and use `arg.span` directly again, so macro-expanded args (e.g. `writeln!`) produce spans outside the call's context, giving a wrong suggestion/ICE-like span mismatch.
