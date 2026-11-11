# Adapted injection for Use proper InferCtxt when probing for associated types in astconv

Fix: https://github.com/rust-lang/rust/commit/da3ecb09d8dda5293569ebf4e13ade3f7e2825f0

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn `probe_traits_that_match_assoc_ty`.
Re-expresses fix hunk `@@ -2232,6 +2194,60 @@` (new `probe_traits_that_match_assoc_ty`, which uses
`self.infcx()` if present, else builds a new one). The bug (parent behaviour) was always building a fresh
`tcx.infer_ctxt().build()`, so a qself_ty containing inference variables from the FnCtxt's infcx is probed
in an unrelated infcx (ICE/wrong suggestion). I removed the `self.infcx()` lookup and the assert, always using a fresh infcx.
