# Adapted injection for Use delayed bug for normalization errors in drop elaboration

Fix: https://github.com/rust-lang/rust/commit/ac45a672979b28670cf2e5de5afbb0b1fb42c0b2

# Rationale
File: compiler/rustc_mir_transform/src/elaborate_drop.rs, fn `open_drop_for_adt`'s field-collecting helper (the closure that computes `field_ty` for `mk_place_field`, ~line 797).

Fix hunk `@@ -266,19 +266,16 @@` replaced
`.tainted_by_errors.expect("Error in drop elaboration not found by dropck.")` with
`span_delayed_bug(body.span, "Error normalizing in drop elaboration.")`.
In 1.99.1 that code was rewritten to `unwrap_or(field_ty.skip_norm_wip())` (silent fallback). I re-introduced the pre-fix behaviour at that normalization site: on `Err`, `Ty::new_error(tcx, body.tainted_by_errors.expect(...))`, which ICEs when the error came from another item and this body isn't tainted.
