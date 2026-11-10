# Adapted injection for offset_of: Don't require type to be sized

Fix: https://github.com/rust-lang/rust/commit/6c18d1eceff68ede8b0692985fd9b704c7942530

# Rationale
In 1.99.1 `offset_of` is a lang-item intrinsic (`T: PointeeSized`) evaluated in
`compiler/rustc_const_eval/src/interpret/intrinsics.rs`, `sym::offset_of` arm. The old
`rvalue.rs` hunk (`@@ -668,11 +668,16 @@`, removing `assert!(bx.cx().type_is_sized(ty));` for
`NullaryOp(OffsetOf)`) has no counterpart any more. I re-expressed the bug by adding
`assert!(layout.is_sized());` in that arm, i.e. offset_of once again requires a sized type
(the fix's removal of the unconditional `assert!(type_is_sized(ty))` for all NullOps).
