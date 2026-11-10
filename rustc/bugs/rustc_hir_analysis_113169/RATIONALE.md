# Adapted injection for Require any function with a tait in its signature to actually constrain a hidden type

Fix: https://github.com/rust-lang/rust/commit/0bc2001879558ba0d51b6a246f5178853f9ff21e

# Rationale
File: compiler/rustc_hir_analysis/src/collect/type_of/opaque.rs, `TaitConstraintLocator::non_defining_use_in_defining_scope`.

The fix hunk `@@ -259,6 +260,16 @@ impl TaitConstraintLocator` added, in the `if !constrained { debug!("no constraints in typeck results"); if opaque_types_defined_by.contains(&self.def_id) { emit_err(TaitForwardCompat2 ..) } return; }` branch,
an error for a function that has the TAIT in its signature (defines it) but does not constrain it. In 1.99.1 that branch became `non_defining_use_in_defining_scope` (reports `report_item_does_not_constrain_error` and records an error hidden type). I made it a no-op (debug! only), restoring the pre-fix behaviour of silently accepting non-constraining defining-scope functions.
