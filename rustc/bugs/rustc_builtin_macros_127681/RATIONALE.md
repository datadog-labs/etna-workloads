# Adapted injection for derive(SmartPointer): rewrite bounds in where and generic bounds

Fix: https://github.com/rust-lang/rust/commit/e7f89a7eea766af95604405d666e089a42cd4b48

Bug: derive(SmartPointer/CoercePointee) did not rewrite `#[pointee]` uses in bounds (generic param bounds, where clauses, and `__S`'s own bounds) with `__S`.
All hunks in compiler/rustc_builtin_macros/src/deriving/coerce_pointee.rs, `expand_deriving_coerce_pointee` (file was smart_ptr.rs upstream):
1. "Rewrite generic parameter bounds" loop: `if idx != pointee_param_idx` -> `if false && ...`, so no `U: Trait<__S>` bounds are pushed. Re-expresses the fix hunk `@@ -141,33 +145,239 @@` that added the loop with `params.bounds.push(bound)`.
2. "Insert `__S`": the substitution over `self_bounds` is iterated with `.take(0)` (no rewrite of `T`'s bounds into `__S`'s). Same hunk (`for bound in &mut self_bounds { substitution.visit_param_bound(...) }`).
3. "Rewrite where clauses": iteration `.take(0)` so no where predicates are rewritten/pushed. Same hunk (`impl_generics.where_clause.predicates.push(predicate)`).
