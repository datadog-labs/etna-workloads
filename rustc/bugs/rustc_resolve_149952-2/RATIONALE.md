# Adapted injection for Suggest struct pattern when destructuring Range with .. syntax

Fix: https://github.com/rust-lang/rust/commit/cb301751b3ade3cf65f1d3eeb0c94ffce1a45561

compiler/rustc_resolve/src/late/diagnostics.rs, smart_resolve_report_errors: removed the call
`self.suggest_range_struct_destructuring(&mut err, path, source);`
Re-expresses fix hunk `@@ -440,6 +440,7 @@` (added that call after suggest_at_operator_in_slice_pat_with_range).
The function itself (hunk 2, which failed to reverse by patch) is kept, marked #[allow(dead_code)] to avoid a warning.
