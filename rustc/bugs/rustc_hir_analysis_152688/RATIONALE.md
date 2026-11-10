# Adapted injection for Trait aliases: Imply default trait bounds on type params other than `Self`

Fix: https://github.com/rust-lang/rust/commit/9d627dd7961cc6a693dcaaf4135e350448a3f1bd

# Hunk: compiler/rustc_hir_analysis/src/collect/clauses_of.rs, `ItemCtxt::probe_ty_param_bounds_in_generics`
(file was renamed from predicates_of.rs in 1.99.1.)
Removed the `if let PredicateFilter::All = filter { for param in hir_generics.params { ... add_implicit_sizedness_bounds / add_default_traits with ImpliedBoundsContext::TyParam ... } }` block.
Re-expresses fix hunk `@@ -979,6 +979,32 @@ impl<'tcx> ItemCtxt<'tcx>` which added that block; removing it restores the bug (type params of trait aliases lack implied default bounds).
