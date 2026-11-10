# Adapted injection for Fix suggestions span for when expr is from macro expansions

Fix: https://github.com/rust-lang/rust/commit/25d065b2d476053102b05bbd5c4650a86ddc2c94

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, fn `suggest_deref_ref_or_into` (the "call `Into::into` on this expression" suggestion).

Re-expresses fix hunk `@@ -1177,10 +1182,16 @@`: the fix computes a `span` that walks up `parent_callsite()` while in the same ctxt as `expr` and uses it for `.into()` suggestion. In 1.99.1 that logic became `expr.span.find_ancestor_not_from_extern_macro(..).unwrap_or(expr.span)`; I replaced it with plain `expr.span`, restoring the old behaviour (suggestion span from macro expansion, so `.into()` inserted/deleting macro text wrongly).
The first fix hunk (return suggestion with find_ancestor_inside) is already present differently in 1.99.1 and was left untouched.
