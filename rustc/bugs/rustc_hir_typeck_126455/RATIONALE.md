# Adapted injection for For [E0308]: mismatched types, when expr is in an arm's body, not add semicolon ';' at the end of it.

Fix: https://github.com/rust-lang/rust/commit/e8b5ba111141c4ec8e26fdeac53f56b6a60da766

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, fn suggest_missing_return_expr-area (the "you might have meant to return this value" suggestion).
Re-expresses fix hunk `@@ -1125,12 +1123,56 @@ impl<'a, 'tcx> FnCtxt<'a, 'tcx>`: removed the `is_in_arm` helper and the conditional
`if !is_in_arm(expr, self.tcx) { suggs.push((span.shrink_to_hi(), ";"...)) }`; restored the unconditional
`vec![(lo, "return "), (hi, ";")]` so a `;` is appended even when the expr is a match arm body. Also reverted to
`multipart_suggestion` (non-verbose) as in the pre-fix code. The import hunk (@@ -27,10) was not needed (TyCtxt import was already unused-safe).
