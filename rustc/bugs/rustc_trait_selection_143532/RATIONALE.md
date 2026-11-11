# Adapted injection for More carefully consider span context when suggesting remove &mut

Fix: https://github.com/rust-lang/rust/commit/b63f920ccf6e148547aea4c0fd045c4536aac483

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn `peel_expr_refs` (the old inline loop moved here).
Re-expresses the fix hunk `@@ -1511,12 +1511,15 @@`: the fix replaced
`if expr.span.eq_ctxt(borrowed.span) { expr.span.until(borrowed.span) } else { expr.span.with_hi(expr.span.lo()+BytePos(1)) }`
with `borrowed.span.find_ancestor_inside(expr.span)` (break 'outer on None). I restored the old eq_ctxt/until/with_hi form, so spans from macro expansions (`&mut vec![1]`) yield a bad suggestion span.
