# Adapted injection for Dont ICE on copy error being suppressed due to overflow

Fix: https://github.com/rust-lang/rust/commit/b5d36e5294d3354ad8feec86b27c698e368c88a6

# Rationale
compiler/rustc_borrowck/src/diagnostics/move_errors.rs, `has_ambiguous_copy`: removed the
`&& self.infcx.tcx.ensure_result().coherent_trait(copy_def_id).is_err()` condition (1.99.1's form of the fix's added
`&& self.infcx.tcx.coherent_trait(copy_def_id).is_err()`, hunk `@@ -303,10 +303,11 @@ ... fn has_ambiguous_copy`).
Back to the old behaviour: any `may_apply()` Copy ambiguity (e.g. overflow) suppresses the move error, which ICEs.
