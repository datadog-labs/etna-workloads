# Adapted injection for Fix malformed suggestion for repeated maybe unsized bounds

Fix: https://github.com/rust-lang/rust/commit/e13eb37eeb3ccb447f33496fe86d77498558d2d5

# Rationale
Only hunk changed: compiler/rustc_hir/src/hir.rs, `Generics::span_for_bound_removal`.
Re-expresses fix hunk `@@ -766,15 +766,21 @@ impl<'hir> Generics<'hir>` (reverse): restores the old logic
(bound_pos == 0 => `span.to(bounds[1].span().shrink_to_lo())`, else `bounds[bound_pos-1].span().shrink_to_hi().to(span)`)
instead of "include following '+' if not last, else preceding '+'". With repeated `?Sized` bounds the removal spans overlap, giving malformed suggestions.
The diagnostics.rs hunk (and `pub fn span_for_predicate_removal`) is already present in 1.99.1 and left unchanged.
