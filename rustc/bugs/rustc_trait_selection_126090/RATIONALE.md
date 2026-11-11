# Adapted injection for Fix unsoundness when associated types dont actually come from supertraits

Fix: https://github.com/rust-lang/rust/commit/172cf9bef3411d479a0be98827647150cce48afd

# Rationale
File: compiler/rustc_trait_selection/src/traits/dyn_compatibility.rs, `IllegalSelfTypeVisitor::is_supertrait_of_current_trait`.
Re-expresses the fix hunk `@@ -738,130 +737,175 @@ enum AllowSelfProjections` in which the supertraits list changed from
`Option<Vec<DefId>>` (`supertrait_def_ids`, compared by def id only) to `Vec<ty::TraitRef>` compared via `.contains(&trait_ref)`
(full trait-ref equality, including generic args). The bug: only the trait's DefId was compared, so `<Self as Super<Other>>::X`
was treated as a supertrait projection when the real supertrait is `Super<Self::Y>`, allowing unsound dyn types.
Change: replaced the erase+`contains(&trait_ref)` with `supertraits.iter().any(|s| s.def_id == trait_ref.def_id)`.
