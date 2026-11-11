# Adapted injection for Fix substitution bug

Fix: https://github.com/rust-lang/rust/commit/77ea90ec71926df7d478834d34d1fefce40cc456

# Rationale
One hunk: compiler/rustc_trait_selection/src/traits/project.rs, `compute_inherent_assoc_term_args`.

In 1.99.1 the astconv code in the fix (`lookup_inherent_assoc_ty`) was rewritten. Alias args are now `[self_ty, ..]`, and the impl args are inferred later by unifying the impl type with the self type, then `rebase_inherent_args_onto_impl(impl_args)`.
The buggy behaviour is re-expressed by substituting with the ADT's args instead of the inferred impl args.
This re-expresses fix hunk `@@ -2275,23 +2276,19 @@` in astconv/mod.rs:
- `-// FIXME(fmease, #107468, #105305): Don't use `adt_substs` here but `impl_substs`.`
- `-    adt_substs,`
- `+    self.create_substs_for_associated_item(span, assoc_item, segment, impl_substs)`

The override applies only when the self type is an ADT and the arg counts match. For `impl<T> S<(T,)>`, `S<(i32,)>::Un` then becomes `(i32,)` instead of `i32`.
The errors.rs hunks (candidates type refactor) are not behavioural and were not re-expressed.
