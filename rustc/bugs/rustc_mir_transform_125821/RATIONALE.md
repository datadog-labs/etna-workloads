# Adapted injection for check index `value <= 0xFFFF_FF00`

Fix: https://github.com/rust-lang/rust/commit/d3c8e6788cfbcc64ab7710cab7a56e276e7d5a7a

# Rationale
File: compiler/rustc_mir_transform/src/known_panics_lint.rs, `Value::project`, `PlaceElem::Index` arm.
Re-expresses fix hunk `@@ -102,8 +102,12 @@ impl<'tcx> Value<'tcx>`: removed the `if idx <= FieldIdx::MAX_AS_U32 { ... } else { return None; }` check, restoring
`fields.get(FieldIdx::from_u32(idx.try_into().ok()?))`, so indices in (0xFFFF_FF00, u32::MAX] hit the FieldIdx::from_u32 assertion (ICE, #121126).
