# Adapted injection for Account for bare tuples in field searching logic

Fix: https://github.com/rust-lang/rust/commit/26c12c746296e01c2dc13d8078b0a2f1569fcb1c

# Rationale
File: compiler/rustc_hir_typeck/src/expr.rs, fn get_field_candidates_considering_privacy_for_diag.
Removed the `ty::Tuple(types) => { return Some(types.iter().enumerate().take(100).map(|(i, ty)| (Ident::from_str(&i.to_string()), ty)).collect()) }` arm.
This re-expresses the fix hunk `@@ -3431,9 +3430,25 @@` (the added `ty::Tuple(types)` arm), so bare tuples are no longer searched for fields (only ty::Adt), restoring the pre-fix behaviour. The other hunks (signature refactor) are not needed to reintroduce the behaviour.
