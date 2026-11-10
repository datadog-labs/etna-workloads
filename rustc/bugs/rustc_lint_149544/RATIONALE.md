# Adapted injection for Only apply `no_mangle_const_items`'s suggestion to plain const items

Fix: https://github.com/rust-lang/rust/commit/6ce0f0ff91b6ed95326b7e14dc6f449d75aff92c

# Rationale
compiler/rustc_lint/src/builtin.rs, `InvalidNoMangleItems::check_item`, `hir::ItemKind::Const` arm.
Re-expresses fix hunk `@@ -997,18 +997,23 @@` in builtin.rs: the fix only computes the `pub static` suggestion
when `generics.params.is_empty() && generics.where_clause_span.is_empty()` (else `None`).
The bug re-injected: suggestion is always `Some(it.span.until(ident.span))`, even for generic / where-clause consts.
(The lints.rs `Option<Span>` hunk already exists in 1.99.1, so no change needed there.)
