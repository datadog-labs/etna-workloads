# Adapted injection for A custom error message for lending iterators

Fix: https://github.com/rust-lang/rust/commit/d6e4fe569c84c6a9d20690f139ad15a3d3da9550

# Rationale
compiler/rustc_resolve/src/late.rs, anonymous-lifetime error path in the non-GAT assoc type branch (moved from the fix's location; diagnostics now in diagnostics/mod.rs).
Removed the `if def_id_matches_path(..., ["core","iter","traits","iterator","Iterator"]) { emit_err(LendingIteratorReportError{..}) } else {..}` special case, so `impl Iterator for X { type Item = &str; }` gets the generic anonymous-lifetime error again.
Re-expresses fix hunk `@@ -1703,10 +1703,28 @@` (the "Is it caused by user trying to implement a lending iterator?" branch).
