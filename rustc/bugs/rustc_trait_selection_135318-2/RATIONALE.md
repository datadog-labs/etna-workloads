# Adapted injection for Normalize vtable entries before walking and deduplicating them

Fix: https://github.com/rust-lang/rust/commit/739ef83f318defbb9692029fa98f56639896c6fd

# Rationale
One hunk: compiler/rustc_trait_selection/src/traits/vtable.rs, `prepare_vtable_segments_inner` (direct_super_traits_iter).
Re-expresses fix hunk `@@ -127,16 +126,15 @@ fn prepare_vtable_segments_inner`: the fix replaced
`instantiate_bound_regions_with_erased(...as_trait_clause()?).trait_ref` with a `.map(... tcx.normalize_erasing_late_bound_regions(TypingEnv::fully_monomorphized(), pred).trait_ref)`.
I restored the old un-normalized supertrait trait_refs, so vtable entries are walked/deduplicated without normalization.
Other fix hunks (cast.rs assertion, at.rs ToTrace impls, debug_assert, eq_trace) are not needed for the bug.
