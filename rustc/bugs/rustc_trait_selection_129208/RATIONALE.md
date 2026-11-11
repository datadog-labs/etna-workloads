# Adapted injection for Fix order of normalization and recursion in const folding.

Fix: https://github.com/rust-lang/rust/commit/7fd62320feddcb3fa85a3ab25bc4c0ac55ddac7c

# Rationale
File: compiler/rustc_trait_selection/src/traits/query/normalize.rs, `QueryNormalizer::try_fold_const`.
Re-expresses the fix hunk `@@ -333,14 +333,14 @@` (normalize first, then `try_super_fold_with`; reversed here).
In 1.99.1 the code evaluates Anon alias consts and then super-folds. I restored the old order for Anon consts:
super-fold the constant first, then evaluate it (`evaluate_const` inside `with_replaced_escaping_bound_vars`).
So normalization is no longer idempotent: the result of evaluation is not re-folded. Assoc/free alias consts are unchanged.
