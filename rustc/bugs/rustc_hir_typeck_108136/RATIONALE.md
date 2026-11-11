# Adapted injection for Do not ICE on unmet trait alias impl bounds

Fix: https://github.com/rust-lang/rust/commit/a1468ae00d559e0647c98a6015a35c50e5551704

# Rationale
File compiler/rustc_hir_typeck/src/method/suggest.rs, function that builds unmet-predicate notes (`suggest_traits_to_import`/report_no_match_method_error helper, near the `skip_list.insert(p)` match arm).
Removed `| hir::ItemKind::TraitAlias(_, ident, ..)` from the `Node::Item` pattern, leaving only `hir::ItemKind::Trait { ident, .. }`.
Re-expresses the fix hunk `@@ -714,7 +714,9 @@` which changed `kind: hir::ItemKind::Trait(..)` to `kind: hir::ItemKind::Trait(..) | hir::ItemKind::TraitAlias(..)`.
Without it, predicates whose cause is a trait alias aren't handled by this arm (the note for `IteratorAlias` is lost / falls to another arm).
