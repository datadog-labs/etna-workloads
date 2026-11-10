# Adapted injection for fix ICE in check_unique

Fix: https://github.com/rust-lang/rust/commit/92f40b8059096c8cc868c1116a31a6d2eea8bc71

# Rationale
File: compiler/rustc_borrowck/src/region_infer/opaque_types/mod.rs, fn `collect_defining_uses`.

Fix hunk `@@ -69,9 +69,18 @@ impl<'tcx> RegionInferenceContext<'tcx>` added
"Ignore non-universal regions because they result in an error eventually"
(`let Some(r1) = self.universal_name(r1) else { continue; }`) before emitting
`LifetimeMismatchOpaqueParam`. In 1.99.1 the unwrap is gone (args are `GenericArg`s) and the equivalent
filtering is the `continue` after a non-defining use (e.g. `NotAParam`, a non-universal region arg) is
recorded as `InvalidOpaqueTypeArgs`. I removed that `continue` for `NotAParam` on the stable-solver path, so such uses
reach the `LifetimeMismatchOpaqueParam` check and cause a spurious second error.
