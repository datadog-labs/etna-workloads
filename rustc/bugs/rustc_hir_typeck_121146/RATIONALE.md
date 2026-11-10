# Adapted injection for Only point out non-diverging arms for match suggestions

Fix: https://github.com/rust-lang/rust/commit/c763f833d14d31fbe63e0b26370a23a51b4f11c5

# Hunk: compiler/rustc_hir_typeck/src/_match.rs, FnCtxt::check_match
Fix hunk `@@ -142,16 +142,16 @@` replaced unconditional `other_arms.push(arm_span)` (with the >5 trim) by pushing
`prior_non_diverging_arms` only inside `if !arm_ty.is_never()`. I moved the push/trim back outside that
`if`, so diverging (`!`) arms are again recorded as prior arms and highlighted in diagnostics.
The renames in the other hunks (infer/error_reporting, traits/mod.rs) are cosmetic and were not reverted.
