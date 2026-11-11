# Adapted injection for Suggest async block instead of async closure when possible

Fix: https://github.com/rust-lang/rust/commit/448097dd2386957a36880efbb78cb83021774540

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn `suggest_add_result_as_return_type`-adjacent callable-call suggestion (`suggest_fn_call`).
Removed the whole block "If this is a zero-argument async closure directly passed as an argument ... suggest using `async {}`" (in 1.99.1 an evolved version of the fix's hunk `@@ -798,6 +798,34 @@`, which added `if let ty::CoroutineClosure(def_id, args) = ... span_suggestion_verbose(... "use `async {}` instead of `async || {}` ...")`). Without it, the old behaviour returns: only the "call the closure" suggestion.
