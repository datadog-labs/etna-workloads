# Adapted injection for More precisely detect cycle errors from type_of on opaque

Fix: https://github.com/rust-lang/rust/commit/bf5359882880d1039ec02be420389342f277bc62

# Hunk: compiler/rustc_trait_selection/src/traits/select/mod.rs, constituent_types_for_auto_trait (Opaque arm)
Re-expresses the fix hunk `@@ -2346,14 +2346,15 @@ impl SelectionContext` which replaced
`let ty = self.tcx().type_of(def_id); if ty.skip_binder().references_error() { return Err(...LeakageUnknown) }`
with a `type_of_opaque` match that only errors on a real cycle (`Err(CyclePlaceholder)`).
Buggy behaviour restored: any opaque whose hidden type merely *references an error* is treated as a leakage failure
(not only genuine cycles). In 1.99.1 `SelectionError::OpaqueTypeAutoTraitLeakageUnknown` no longer exists, so
`SelectionError::Unimplemented` is returned. The Result-typed `type_of_opaque` query/CyclePlaceholder plumbing hunks
(erase.rs, query/mod.rs, plumbing.rs, values.rs, type_of.rs, collect.rs) were not reverted: that infrastructure no longer exists in this form.
