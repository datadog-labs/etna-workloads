# Adapted injection for rustc_abi: audit uses of is_zst; fix a case of giving an enum insufficient alignment

Fix: https://github.com/rust-lang/rust/commit/0da9409e083a1da93c183e1167c96d582848847a

# Rationale
File compiler/rustc_abi/src/layout.rs, fn `absent` (free fn near line 90; was a closure in the fix).
Re-expresses fix hunk `@@ -157,8 +157,10 @@ pub trait LayoutCalculator`: replaced
`let is_1zst = fields.iter().all(|f| f.0.is_1zst()); uninhabited && is_1zst` with the old
`let is_zst = ...all(|f| f.is_zst()); uninhabited && is_zst`, so an uninhabited variant with an aligned ZST field (e.g. `[u16;0], !`) is discarded and the enum gets too little alignment.
Other hunks were not changed.
