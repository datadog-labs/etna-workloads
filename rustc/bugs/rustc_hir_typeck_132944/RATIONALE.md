# Adapted injection for add parentheses when unboxing suggestion needed

Fix: https://github.com/rust-lang/rust/commit/949cf61fdce2309920ebfa9f7e8363308fbdac08

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, function `suggest_deref_or_ref` (deref/unbox branch).
Removed the `if expr_needs_parens(expr) { return Some((vec![(span, format!("{suggestion}(")), (expr.span.shrink_to_hi(), ")")], ...)) }` block before the final `return Some((vec![(span, suggestion)], ...))`.
This re-expresses fix hunk `@@ -2869,6 +2861,19 @@` which added `if self.needs_parentheses(expr) { return Some((vec![(span, format!("{suggestion}(")), (expr.span.shrink_to_hi(), ")".to_string())], ...` . Without it, `*x as Box<..>` style suggestions lack parentheses (issue 132924). The other hunks were a refactor into a helper and are not needed.
