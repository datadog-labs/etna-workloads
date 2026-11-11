# Adapted injection for Fill in HIR hash for associated opaque types

Fix: https://github.com/rust-lang/rust/commit/ef5513f278106de9b6c005152fe832be5e197465

# Rationale
One hunk: compiler/rustc_hir/src/hir.rs, `OwnerNodes::synthetic()`: `opt_hash: Some(Fingerprint::ZERO)` -> `opt_hash: None` (comment removed).
In 1.99.1 synthetic owners (incl. associated opaque types fed by `feed_hir` in ty/context.rs, used by rustc_ty_utils/src/assoc.rs) get a constant hash. The fix hunks (`@@ -240,8 +240,14 @@ fn associated_types_for_impl_traits_in_associated_fn`: `-        opt_hash_including_bodies: None,` / `+        opt_hash_including_bodies,`, via `hash_owner_nodes`) filled in the hash for these nodes instead of None. Reverting to None restores the old behaviour (missing HIR hash with incremental/crate hash needed -> ICE in hir-hash.rs).
