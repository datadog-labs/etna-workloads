# Adapted injection for fix homogeneous_aggregate not ignoring some 1-ZST

Fix: https://github.com/rust-lang/rust/commit/254e13d9f9dd38817a28880b99acd29a2fcc5613

# Rationale
File: compiler/rustc_abi/src/callconv.rs (moved from rustc_target/src/abi/call/mod.rs), `TyAndLayout::homogeneous_aggregate`, the `for i in 0..layout.fields.count()` loop in `from_fields_at`.
Re-expresses fix hunk `@@ -441,12 +440,18 @@`: removed the `if field.is_1zst() { continue; }` early skip, and moved the `layout.field(cx, i)` fetch back after the `total != layout.fields.offset(i)` offset check. So 1-ZST fields (e.g. a trailing aligned ZST) are no longer ignored and can cause Heterogeneous / break homogeneity.
