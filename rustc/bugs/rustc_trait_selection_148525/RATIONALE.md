# Adapted injection for Fix ICE from lit_to_mir_constant caused by type error

Fix: https://github.com/rust-lang/rust/commit/eaf979e8dd98f006767632f0910cd2fdecf8541d

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/mod.rs, fn report_fulfillment_errors.
Removed the block
`if let Some(guar) = self.dcx().has_errors() { self.infcx.set_tainted_by_errors(guar); }`
that runs for every non-suppressed error, including ones where `error.references_error()` is true.
This re-expresses the fix hunk `@@ -250,29 +250,30 @@` which added that block (after the `if !error.references_error() {..}`). Without it the infcx is not tainted when only error-referencing obligations are skipped, giving the ICE in lit_to_mir_constant.
