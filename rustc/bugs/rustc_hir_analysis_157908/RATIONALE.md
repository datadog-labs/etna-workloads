# Adapted injection for add suggestion for mgca to add assoc type

Fix: https://github.com/rust-lang/rust/commit/c1f6331d1341a41a58d7d0acd7a9df0574efc388

# Rationale
File: compiler/rustc_hir_analysis/src/diagnostics/wrong_number_of_generic_args.rs, fn `get_unbound_associated_item`.
Re-expresses fix hunk `@@ -485,13 +483,13 @@ ... get_unbound_associated_types`: the fix changed the filter to
`(item.is_type() || item.is_type_const()) && ...`. In 1.99.1 the filter is `item.can_have_equality_constraint(self.tcx)`;
I restored the old `item.is_type()`, so type-const assoc items are not considered unbound and no suggestion to bind them is emitted.
