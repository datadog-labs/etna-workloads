# Adapted injection for point at method call chain when a return-position `impl Trait` assoc type diverges

Fix: https://github.com/rust-lang/rust/commit/9c81f660da8aa35f57b5a37628e0a06a4ab64850

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn `note_obligation_cause_code`, arm `ObligationCauseCode::OpaqueReturnType(expr_info)`.
Removed the block that locates the returned expression and calls `point_at_chain_in_return_position`. Re-expresses fix hunk
`@@ -4487,6 +4487,29 @@` (added "Point at the method call in the returned expression's chain ..."). The second hunk (the helper fn) is left in place (now unused, one dead-code warning), since it did not reverse cleanly.
