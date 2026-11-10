# Adapted injection for Account for trailing comma in removal suggestion

Fix: https://github.com/rust-lang/rust/commit/c85bb274f6376c0e8b1289d6cb8f187b011b8fd7

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn `point_at_assoc_type_restriction`.
The fix hunk `@@ -5118,8 +5121,27 @@` added a block computing the span to delete (including adjacent comma / the whole where clause) and replaced `pred.span, // FIXME: include the trailing comma.` with `span`. In 1.99.1 that block lives in the same function; I removed it and set `let span = curr_span;` (the predicate's own span), restoring the pre-fix behaviour, so the suggestion leaves a dangling `,`.
The peekable/prev bookkeeping (other fix hunks) is left in place since it is now just unused-by-suggestion state (still used by nothing else; harmless).
