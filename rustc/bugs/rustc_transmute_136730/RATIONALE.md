# Adapted injection for transmutability: fix ICE when passing wrong ADT to ASSUME

Fix: https://github.com/rust-lang/rust/commit/c097b2c6bb63e793d30191ffdcaf30c8e0d48607

# Rationale
File compiler/rustc_transmute/src/lib.rs, `Assume::from_const`.
Re-expresses fix hunk `@@ -139,25 +139,21 @@`: the fix replaced `assert_eq!(tcx.require_lang_item(TransmuteOpts..), adt_def.did(), ...)` with an `is_lang_item` check + `delayed_bug` + default Assume. I restored the `assert_eq!` (using DUMMY_SP, as the 1.99 signature takes a Span), so passing a wrong ADT as ASSUME ICEs again.
The other hunks (ValTree import, `unwrap_branch`) don't apply to 1.99 code and aren't needed for the bug.
