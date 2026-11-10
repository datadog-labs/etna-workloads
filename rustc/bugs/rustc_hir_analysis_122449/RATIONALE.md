# Adapted injection for Delay a bug for stranded opaques

Fix: https://github.com/rust-lang/rust/commit/026eb3dd6457f223ff1c3a3b40bf59898a25061a

# Rationale
File: compiler/rustc_hir_analysis/src/check/check.rs

1. `check_opaque_meets_bounds`, `Err(ty_err)` arm of `ocx.eq(...)`: restored `tcx.dcx().span_bug(...)` in place of `span_delayed_bug(...)` + `return Err(guar)`. Re-expresses fix hunk `@@ -381,11 +381,17 @@ fn check_opaque_meets_bounds` (removed the "stranded" comment, `span_bug` instead of `let guar = span_delayed_bug; return Err(guar)`).
2. `check_opaque`: removed the early `if type_of(def_id)...references_error() { return; }`. This guard was added after the fix in 1.99.1 and returns before hunk 1 is reached for the stranded opaque (its hidden type is `{type error}`). Without removing it the bug cannot be observed. Supporting change only.
