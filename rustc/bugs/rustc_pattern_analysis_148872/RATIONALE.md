# Adapted injection for fix: Do not ICE when missing match arm with ill-formed subty is met

Fix: https://github.com/rust-lang/rust/commit/dae003b04b2c2be12a690bc5c82b097b696ea18b

# Rationale
File: compiler/rustc_pattern_analysis/src/rustc.rs, fn `variant_sub_tys`.
Re-expresses the single hunk `@@ -191,7 +191,18 @@ impl<'p, 'tcx: 'p> RustcPatCtxt<'p, 'tcx>`: the fix replaced
`self.tcx.normalize_erasing_regions(self.typing_env, ty)` with `try_normalize_erasing_regions(...).unwrap_or_else(span_delayed_bug; ty)`.
I restored the infallible `normalize_erasing_regions`, which ICEs on ill-formed field types (issue 148192).
