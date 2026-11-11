# Adapted injection for Partially implement `ConstArgHasType`

Fix: https://github.com/rust-lang/rust/commit/d5bd4e233d2bb4415138e384e66379eedbc7e76e

# Rationale
One hunk: compiler/rustc_trait_selection/src/traits/fulfill.rs, `FulfillProcessor::process_obligation`, `ConstArgHasType(ct, ty)` arm.

Re-expresses the fix hunk `@@ -429,16 +429,37 @@ ... ConstArgHasType(ct, ty)` in fulfill.rs, which added
`ty::ConstKind::Infer(ty::InferConst::Var(vid)) => { stalled_on.extend([Const(vid)]); ProcessResult::Unchanged }`
("We do still stall on infer vars though as otherwise ConstArgHasType(?x: usize, usize) can succeed even though it might later get unified with some const that is not of type usize").
The buggy parent did not stall; 1.99.1 code is restructured, so I replaced the stalling Infer arm with an immediate `Changed(empty)`, i.e. an infer-var const trivially satisfies the goal and is never rechecked once resolved.
The other fix hunks (combine.rs type equate, solver mod.rs, error reporting) are already absent/restructured in 1.99.1 and were not touched.
