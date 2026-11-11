# Adapted injection for Check assoc consts and tys later like assoc fns

Fix: https://github.com/rust-lang/rust/commit/889582e704e516ab22a685711ef593a98fd9021a

# Rationale
File compiler/rustc_passes/src/dead.rs, function `create_and_seed_worklist`'s per-item seeding (the `DefKind::AssocFn | AssocConst | AssocTy` / `Impl { of_trait: true }` arm; 1.99.1 equivalent of `check_item`).
Re-expresses fix hunk `@@ -744,18 +772,12 @@ fn check_item`, which removed
`if !matches!(tcx.def_kind(local_def_id), DefKind::AssocFn) { worklist.push(..No) } else { unsolved_items.push(..) }`
so all trait-impl assoc items go into unsolved_items. Bug restored: impl assoc consts/types of traits are pushed straight to the worklist as live, so they're never dead-code checked.
