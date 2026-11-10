# Adapted injection for diagnostics: point to coroutine body on higher-ranked auto trait errors

Fix: https://github.com/rust-lang/rust/commit/25acba896325cd73a09630e98e836e8096c8a182

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/nice_region_error/placeholder_error.rs, fn report_trait_placeholder_mismatch (the function building TraitPlaceholderMismatch).

Removed the block that walks `cause.code()` (MatchImpl / BuiltinDerived) to find a Coroutine/CoroutineWitness self type and, for auto traits, labels the coroutine span with "this {descr} captures a value whose type is not `{trait}`". This re-expresses the fix hunk `@@ -340,7 +340,46 @@` (the added `loop { match current_code ... }` and `err.span_label(c_span, ...)`). The `let mut err = ...` binding from hunk `@@ -332,7 +332,7 @@` is left (still mutated later), so the pre-fix behaviour (no label on higher-ranked auto trait errors) returns.
