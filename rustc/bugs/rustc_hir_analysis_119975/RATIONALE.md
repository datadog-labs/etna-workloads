# Adapted injection for Don't ICE if TAIT-defining fn contains a closure with `_` in return type

Fix: https://github.com/rust-lang/rust/commit/450cb5eda6d1db8b5b45a3775cb5316bb623dc63

# Rationale
Hunk 1: compiler/rustc_hir_analysis/src/collect/type_of/opaque.rs, `TaitConstraintLocator::check`.
Re-expresses fix hunk `@@ -135,18 +135,25 @@ impl TaitConstraintLocator<'_>`: the fix replaced `hir_node.fn_decl()` (which includes closures) with `Node::fn_sig()` (excludes closures). Reverted to `hir_node.fn_decl()` / `hir_sig.output`.

Hunk 2: same file, `visit_expr`. In 1.99.1 closures were no longer passed to `check`, so hunk 1 alone had no effect. Re-added `if let ExprKind::Closure(closure) = ex.kind { self.check(closure.def_id) }` so closures reach the buggy fn_decl check (as in the parent commit's visitor). Needed to make hunk 1 observable.
