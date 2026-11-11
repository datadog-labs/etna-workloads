# Adapted injection for fix(diagnostic): wrap parens for ref impl trait param

Fix: https://github.com/rust-lang/rust/commit/b2b2be1cad5a3009f53f490ae09abf33958e40df

# Rationale
File compiler/rustc_hir_typeck/src/method/suggest.rs, the "restrict type parameter" suggestion code (near line 4620).
Removed the block `if rcvr_ty.is_ref() && param.is_impl_trait() && let Some((bounds_span, _)) = bounds_span { err.multipart_suggestions(... "(" at param.span.shrink_to_lo(), " + cand)" ...); return; }`.
This re-expresses the fix hunk `@@ -2633,47 +2633,62 @@` which added
`if rcvr_ty.is_ref() && param.is_impl_trait() && bounds_span.is_some()` and the parenthesised multipart suggestion. Without it, `&impl Trait` gets the unparenthesised `&impl Foo + Bar` suggestion.
