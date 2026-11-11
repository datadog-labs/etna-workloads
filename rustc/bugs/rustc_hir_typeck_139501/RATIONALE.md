# Adapted injection for Fix stack overflow in exhaustiveness due to recursive HIR opaque type values

Fix: https://github.com/rust-lang/rust/commit/b08e9c2a60f4dbab4bdaa733727947b3395de329

# Rationale
The fix added `RecursiveOpaque` in rustc_pattern_analysis/src/rustc.rs (`reveal_opaque_key`; hunks
`@@ -135,11 +137,22 @@` "HACK: We skip revealing opaque types which recursively expand to themselves" and
`@@ -1105,3 +1118,20 @@` struct RecursiveOpaque) so exhaustiveness does not reveal recursive hidden types.
In 1.99.1 that code is gone; the equivalent protection is the `recursive_opaques` filter with
`HasRecursiveOpaque` in rustc_hir_typeck/src/writeback.rs (`visit_opaque_types`), which turns recursive hidden types
into errors (E0720) before pattern analysis sees them. I disabled that filter (`false && hidden_ty...`),
so recursive hidden types are again passed unguarded to exhaustiveness (the pre-fix behaviour).
