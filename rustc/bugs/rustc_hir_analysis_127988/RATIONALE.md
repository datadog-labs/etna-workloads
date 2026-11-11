# Adapted injection for Do not ICE with incorrect empty suggestion

Fix: https://github.com/rust-lang/rust/commit/bd8e88fd7b2401242cbcc95d88ef7b8058d59a77

# Rationale
File: compiler/rustc_hir_analysis/src/diagnostics/wrong_number_of_generic_args.rs (moved from errors/), fn suggest_removing_args_or_generics.
Removed the `if span.is_empty() { /* HACK ... */ } else { ... }` guard, so `err.span_suggestion(span, msg, "", MaybeIncorrect)` is always emitted, even for an empty span.
Re-expresses fix hunk `@@ -1048,7 +1048,17 @@ impl<'a, 'tcx> WrongNumberOfGenericArgs<'a, 'tcx>` (added `if span.is_empty() {...} else { err.span_suggestion(span, msg, "", ...) }`).
