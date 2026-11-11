# Adapted injection for Fix lifetime suggestion for type aliases with objects in them

Fix: https://github.com/rust-lang/rust/commit/183f1a6a7048e1d35521941c23ec43078ea0a038

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/region_errors.rs, fn suggest_adding_lifetime_to_alias (the `return_type_impl_or_dyn_traits_with_type_alias` consumer).
Re-expresses fix hunk `@@ -858,10 +858,20 @@`: the fix added
`if let Some(lt_addition_span) = lt_addition_span { push((lt_addition_span, "'a, ")) } else { push(alias_span.shrink_to_hi(), "<'a>") }`.
Buggy parent behaviour restored: always push `<'a>` after the alias generics span, so aliases with existing generics (`Lazy<T>`) get `Lazy<T><'a>`-style bad suggestion. The tcx side (context.rs) already returns the third tuple element; it is ignored.
