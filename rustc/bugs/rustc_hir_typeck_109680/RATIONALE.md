# Adapted injection for Fix subslice capture in closure

Fix: https://github.com/rust-lang/rust/commit/f995003ec5053c85efca895d0506392d3be88286

# Rationale
File compiler/rustc_hir_typeck/src/upvar.rs, fn restrict_capture_precision (~line 2290).
Re-expresses the fix hunk `@@ -1893,14 +1893,13 @@ fn restrict_capture_precision`: the fix changed
`ProjectionKind::Index => {` to `ProjectionKind::Index | ProjectionKind::Subslice => {` and removed
`ProjectionKind::Subslice => {}  // We never capture this`. I restored the old arm: Subslice no longer truncates the
captured place (so a subslice projection is captured precisely), and the ignore arm is back.
