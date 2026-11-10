# Adapted injection for Make sure we can produce ConstArgHasWrongType errors for valtree consts

Fix: https://github.com/rust-lang/rust/commit/516a93353d63ab9079e5ea5709f338f14d165272

# Rationale
File: compiler/rustc_trait_selection/src/solve/fulfill/derive_errors.rs (fulfillment_error_for_no_solution; moved from solve/fulfill.rs).
Removed the arm `ty::ConstKind::Value(cv) => cv.ty,` (fix hunk `@@ -264,9 +264,10 @@` added `ty::ConstKind::Value(ty, _) => ty,`). Without it, a failed ConstArgHasType goal on a valtree const hits the span_bug ICE instead of producing ConstArgHasWrongType. (The fix's message tweak `{kind:?}` already exists and is left as is.)
