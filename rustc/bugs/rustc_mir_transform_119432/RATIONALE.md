# Adapted injection for Enable `ConstPropLint` for promoteds

Fix: https://github.com/rust-lang/rust/commit/5010ca001cb7cad425b906136fe251e8d8192b2e

# Rationale
File: compiler/rustc_mir_transform/src/known_panics_lint.rs, `KnownPanicsLint::run_lint` (ConstPropLint was renamed to KnownPanicsLint).
Re-adds the early return for promoted bodies, reversing the fix hunk
`@@ -32,11 +32,6 @@ impl<'tcx> MirLint<'tcx> for ConstPropLint` which removed
`if body.source.promoted.is_some() { return; }` ("will be evaluated by miri and produce its errors there").
