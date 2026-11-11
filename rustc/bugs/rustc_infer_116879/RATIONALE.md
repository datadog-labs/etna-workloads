# Adapted injection for revert rust-lang/rust#114586

Fix: https://github.com/rust-lang/rust/commit/a1e274f1721f6be4a36afe10e57a6825eeeaf848

# Rationale
Only one hunk, in compiler/rustc_infer/src/infer/opaque_types/mod.rs, `InferCtxt::handle_opaque_type`.

Fix hunk re-expressed: `@@ -145,25 +145,7 @@ impl<'tcx> InferCtxt<'tcx>` in rustc_infer/src/infer/opaque_types.rs, where the fix
removes the `DefiningAnchor::Bubble` branch that, when `b` is also an opaque type, returned an
`AliasRelate(a, b, Equate)` obligation instead of defining a hidden type.
The old solver's AliasRelate / Bubble machinery no longer exists in 1.99.1 (the other hunks, in borrowck,
fulfill.rs and select/mod.rs, have no counterpart). The closest analogue is the opaque-vs-opaque case in
`handle_opaque_type`. I added a check that, if the other opaque is not definable in the current typing mode,
returns `None` so the two opaques can't be related (the equality fails). The effect is that opaque-vs-opaque
equality in a query context, which the Bubble/AliasRelate path handled, is no longer handled.
This is an approximation of the upstream bug, not a literal reversal.
