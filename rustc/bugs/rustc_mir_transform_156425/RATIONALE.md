# Adapted injection for Fix unused assignments in diverging branches

Fix: https://github.com/rust-lang/rust/commit/64e93266ceccda77d751912a3d13ea4e87cddacf

# Rationale
One hunk, compiler/rustc_mir_transform/src/liveness.rs, in `AssignmentResult::report_unused_assignments` (the per-place loop over `statements`).
Re-expresses the last fix.diff hunk `@@ -1098,31 +1128,34 @@`: the fix replaced `next_direct_assign: Option<Span>` with `next_direct_assignments: Vec<(Span, Location)>` and only reported an overwrite when `location.is_predecessor_of(overwrite_location)`; also computed `should_report` so overwrite only for dead assignments.
Reintroduced the old behaviour: a single `next_direct_assign` span, and any earlier direct assignment gets an overwrite note regardless of control-flow reachability (so diverging branches get the "reassigned later" note instead of the plain "maybe overwritten" help). The `location` field of `Access` (other hunks) is left in place but ignored.
