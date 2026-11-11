# Adapted injection for Taint infcx when reporting errors

Fix: https://github.com/rust-lang/rust/commit/3594a19f2ae792cf99a1a78a5454e52cfd7affde

# Rationale
Files: compiler/rustc_trait_selection/src/error_reporting/traits/{mod.rs,ambiguity.rs} (code moved from type_err_ctxt_ext.rs in 1.99.1).

1. mod.rs, `report_fulfillment_errors`: removed `self.infcx.set_tainted_by_errors(guar)` after `report_fulfillment_error` (and the trailing `has_errors()` taint block, which is the 1.99.1 form of the same behaviour). Re-expresses fix hunk `@@ -179,6 +179,7 @@ ... let guar = self.report_fulfillment_error(error); + self.infcx.set_tainted_by_errors(guar);`.
2. ambiguity.rs, ambiguity reporting: `ConstArgHasType(ct, ..)` arm restored to the old `span_delayed_bug("ambiguous ConstArgHasType(..) unaccompanied by inference error")` instead of `emit_inference_failure_err` E0284. Re-expresses hunk `@@ -2686,22 +2687,14 @@` (the reverse of its +/- lines).
