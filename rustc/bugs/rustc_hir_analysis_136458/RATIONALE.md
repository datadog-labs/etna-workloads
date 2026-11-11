# Adapted injection for Do not deduplicate list of associated types provided by dyn principal

Fix: https://github.com/rust-lang/rust/commit/72bd174c43406068727e17cbf6fc2f4e1a36f6af

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs (was dyn_compatibility.rs), `lower_trait_object_ty`.

One hunk. It re-expresses the fix hunk `@@ -198,9 +253,22 @@` in dyn_compatibility.rs. That hunk added
`let projection_bounds: Vec<_> = needed_associated_types.into_iter().filter_map(|key| projection_bounds.get(&key) ...)`.
The final projection list holds exactly one entry per needed assoc type, and the list is no longer deduplicated afterwards.
In the buggy parent the final list was every collected projection bound (user-written, trait-alias and supertrait-derived), not filtered or ordered by the needed associated types.
I restored that. `projection_bounds` is now all map values, and the missing-assoc-item check is done separately against it.
Other parts of the fix (the relate.rs dedup removal, the elaborate.rs rename) are already in 1.99.1 or are refactors, so I left them.
