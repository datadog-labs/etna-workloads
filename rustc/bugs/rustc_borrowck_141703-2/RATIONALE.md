# Adapted injection for Structurally normalize types as needed in projection_ty_core

Fix: https://github.com/rust-lang/rust/commit/2a339ce492349a27c80a0bb9e63510f1798beae1

# Rationale
One hunk: compiler/rustc_borrowck/src/type_check/mod.rs, `TypeChecker::relate_type_and_user_type` (the `projection_ty_core` call).

1.99.1's `handle_field` closure normalizes the projected field type (`self.normalize(PlaceTy::field_ty(..), locations)`). I removed that normalization, so the field type is left unnormalized (`.skip_norm_wip()`).
This re-expresses the fix's hunk `@@ -474,17 +474,15 @@ ... relate_type_and_user_type`. That hunk added `|ty| self.structurally_resolve(ty, locations)` and `self.normalize(curr_projected_ty.ty, locations)`, so the old code was the one with no normalization after the projection elems.
The middle/mir_build hunks of the fix (the `field_ty` signature refactor) are already applied in 1.99.1. They are plumbing and don't affect behaviour, so I left them alone.
