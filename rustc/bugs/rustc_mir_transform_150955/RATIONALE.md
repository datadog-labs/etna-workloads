# Adapted injection for Underscore-prefixed bindings are explicitly allowed to be unused

Fix: https://github.com/rust-lang/rust/commit/ea93fb548c7c6e838b35893f3f9cc2ed3011aaea

# Hunk: compiler/rustc_mir_transform/src/liveness.rs, AssignmentResult::report_unused_assignments (loop over self.assignments)
Removed the `if name.as_str().starts_with('_') { continue; }` skip ("By convention, underscore-prefixed bindings are allowed to be unused explicitly"). This re-expresses the fix hunk `@@ -1086,6 +1086,11 @@ impl<'a, 'tcx> AssignmentResult<'a, 'tcx>` which added
`// By convention, underscore-prefixed bindings are explicitly allowed to be unused. if name.as_str().starts_with('_') { continue; }`. In 1.99.1 the check sits after the maybe_drop_guard computation; removing it restores the buggy behaviour (underscore-prefixed captured bindings get unused_assignments reported).
