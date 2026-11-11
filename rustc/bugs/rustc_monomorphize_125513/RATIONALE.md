# Adapted injection for Don't eagerly monomorphize drop for types that are impossible to instantiate

Fix: https://github.com/rust-lang/rust/commit/045f448e26257c7b19bf6d68c8e5e9d09ab4df79

# Rationale
File: compiler/rustc_monomorphize/src/collector.rs, `RootCollector::process_item` (ADT arm).
Removed the `if self.tcx.instantiate_and_check_impossible_clauses((id.owner_id.to_def_id(), id_args)) { return; }` early return (the 1.99.1 form of the fix's
`@@ -1434,6 +1434,15 @@ impl<'v> RootCollector` hunk, which added `instantiate_and_check_impossible_predicates(...) { return; }`).
Without it, drop glue is eagerly monomorphized for ADTs with impossible predicates.
