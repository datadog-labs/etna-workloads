# Adapted injection for Dont suggest `!` for path in function call if it has generic args

Fix: https://github.com/rust-lang/rust/commit/8490b8ec63782938cc529b7f09518944f907744a

compiler/rustc_resolve/src/late/diagnostics.rs, smart_resolve_context_dependent_help (macro-found-as-function arm, `Res::Def(DefKind::Macro..)` with Call/Index/Struct source):
removed the `path.last().is_some_and(|s| !s.has_generic_args && !s.has_lifetime_args)` guard, so "use `!` to invoke the macro" is suggested even with generic args (`assert_eq::<()>()`).
Re-expresses fix hunk `@@ -1523,12 +1525,20 @@` (the guard added around span_suggestion_verbose, "Don't suggest `!` ... if there are generic args"). The `path` parameter plumbing hunks were left in place (unused-variable is harmless since `path` is still used elsewhere or just a param).
