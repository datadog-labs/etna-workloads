# Adapted injection for Fix ICE when suggesting closures for non-fn-like defs

Fix: https://github.com/rust-lang/rust/commit/a2171feb3384d5737eaf7ca24c5740a9615b2917

File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs (the code moved from traits/error_reporting/suggestions.rs), in the closure-suggestion function (`suggest_closure`-style code near the `args_have_same_underlying_type` check).
1. Removed `&& res_kind.is_fn_like()` and rebound `Res::Def(res_kind, ..)` to `Res::Def(_, ..)`. Re-expresses hunk `@@ -2112,7 +2112,8 @@` (`+ && res_kind.is_fn_like()`). Non-fn-like defs (enum variant constructors etc.) now go on to the closure suggestion.
2. Removed the `ty.references_error()` => `": /* type */"` branch in the arg-name formatting. Re-expresses hunk `@@ -2155,7 +2156,13 @@`.
