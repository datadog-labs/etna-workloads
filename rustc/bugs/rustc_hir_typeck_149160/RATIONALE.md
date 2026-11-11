# Adapted injection for Check for intrinsic to fn ptr casts in unified coercions

Fix: https://github.com/rust-lang/rust/commit/ebf1c38aa67f113c3a638fe467c75b0b154c903c

# Rationale
File: compiler/rustc_hir_typeck/src/coercion.rs.
Fix hunk `@@ -1291,14 +1291,26 @@ coerce_lub` added the `tcx.intrinsic(def_id).is_some() -> IntrinsicCast` check on the unified (LUB) FnDef->fnptr path. In 1.99.1 that check lives in the shared `sig_for_fn_def_coercion`. I removed it there and re-added it only in the single-coercion caller (`coerce_from_fn_item`, before `sig_for_fn_def_coercion(a, Some(b_hdr.safety()))`), so the LUB path (`sig_for_coerce_lub`) no longer checks, restoring the old behaviour (ICE/unchecked intrinsic reify).
