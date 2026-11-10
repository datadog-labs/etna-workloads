# Adapted injection for Print note with closure signature on type mismatch

Fix: https://github.com/rust-lang/rust/commit/be564a8add9b05624274af0d729afdb16674a97d

Hunk: compiler/rustc_trait_selection/src/error_reporting/infer/mod.rs, TypeErrCtxt::note_type_err (moved from rustc_infer in 1.99.1).
Removed the `if let Some(ty::Closure(_, args)) = exp_found...found.kind() { diag.highlighted_note(["closure has signature: `", signature_unclosure(..), "`"]) }` block.
Re-expresses fix hunk `@@ -1917,6 +1917,23 @@ impl<'tcx> TypeErrCtxt<'_, 'tcx>` in rustc_infer/.../mod.rs, which added that block. The other hunks (import StringPart, making highlighted_note pub) are visibility-only and need no reversal.
