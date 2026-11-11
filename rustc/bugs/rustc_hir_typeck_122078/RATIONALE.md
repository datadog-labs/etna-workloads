# Adapted injection for Check that return type is WF in typeck

Fix: https://github.com/rust-lang/rust/commit/ace436743fff6dcfd21d8194acdd43a94c1611ec

# Hunk: compiler/rustc_hir_typeck/src/lib.rs, typeck_with_inspect (const/static branch)
Removed the WF obligation on the const/static expected type:
    let wf_code = ObligationCauseCode::WellFormed(Some(WellFormedLoc::Ty(def_id)));
    fcx.register_wf_obligation(expected_type.into(), body.value.span, wf_code);
Re-expresses fix hunk `@@ -253,6 +253,10 @@ fn typeck_with_fallback` (added those lines). Also dropped the now-unused `WellFormedLoc` import (fix hunk #1, import change).
