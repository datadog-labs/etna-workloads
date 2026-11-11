# Adapted injection for Apply effects to otherwise edge in dataflow analysis

Fix: https://github.com/rust-lang/rust/commit/c7ef03aeb7c33825e3d020c9e1791171e71cd445

Bug: otherwise-edges of SwitchInt did not apply inactive-variant effects (parent behaviour).

1. rustc_mir_transform/src/elaborate_drops.rs, ElaborateDrops::run_pass: removed `.exclude_inactive_in_otherwise()` on MaybeInitializedPlaces. Re-expresses hunk `@@ -62,12 +62,14 @@` which added `.exclude_inactive_in_otherwise()` (and `.include_inactive_in_otherwise()` for uninits).
2. rustc_mir_dataflow/src/impls/initialized.rs, MaybeUninitializedPlaces::apply_switch_int_edge_effect: `SwitchTargetIndex::Otherwise => return` instead of marking all switch variants as inactive. Re-expresses hunk `@@ -544,17 +581,24 @@` (`SwitchTargetValue::Otherwise if self.include_inactive_in_otherwise => Inactives(...)`, `_ => return`); in 1.99.1 the flag is gone/unconditional, so Otherwise is made a no-op (flag false).
