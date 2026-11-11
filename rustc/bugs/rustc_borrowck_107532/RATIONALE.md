# Adapted injection for Erase regions before uninhabited check

Fix: https://github.com/rust-lang/rust/commit/2c23c7f0cd7a665bbd7b173ebfc26cae223304e3

# Rationale
compiler/rustc_borrowck/src/type_check/mod.rs, fn check_call_dest (is_diverging branch): removed the
`erase_and_anonymize_regions(sig.output())` (modern form of `erase_regions`) so `is_privately_uninhabited`
gets the raw signature output with region variables. Re-expresses fix hunk
`@@ -1484,7 +1484,10 @@` (`let output_ty = self.tcx().erase_regions(sig.output());` -> `sig.output().is_privately_uninhabited`).
