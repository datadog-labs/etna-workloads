# Adapted injection for Make resolved GAT paths induce trait object lifetime defaults for their own args (excl. self ty)

Fix: https://github.com/rust-lang/rust/commit/1660db80823046fb01f4885767f2070f6abf7ec0

All changes are in compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs (code was refactored since the fix; logic now lives in `eligible_container` and `compute_object_lifetime_defaults`).

1. `compute_object_lifetime_defaults` -> `set_to_region` -> `resolve_param`: removed the `has_self` subtraction, so `index = index - parent_count`.
   Re-expresses the fix hunk `@@ -1762,12 +1797,31 @@ ...` with `let has_self = generics.has_own_self(); (0, index as usize - generics.parent_count - has_self as usize)`; the old code did not account for the implicit Self param of traits (the commit message's "index calculation ... didn't take into account the implicit self ty param"), breaking trait ref / trait alias defaults.
2. `eligible_container`: `DefKind::AssocTy` with rev_seg_idx 0 now returns `None` (previously `Some((def_id, path.segments))`).
   Re-expresses fix hunk `@@ -1702,30 +1739,31 @@` which added `| DefKind::AssocTy` to the `depth == 0` arm, so resolved GAT paths induce defaults for their own args.
