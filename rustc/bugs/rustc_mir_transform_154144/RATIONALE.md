# Adapted injection for Fix malformed transmute handling during MIR build

Fix: https://github.com/rust-lang/rust/commit/fa6e163896b3c4ef57d6b1aa6c880352a4a60856

# Hunk: compiler/rustc_mir_transform/src/lib.rs, `mir_drops_elaborated_and_const_checked`
Re-expresses the fix hunk `@@ -541,11 +541,15 @@ fn mir_drops_elaborated_and_const_checked`, which added
`if let Err(e) = tcx.check_transmutes(root) { body.tainted_by_errors = Some(e); }`.
The bug version still runs the transmute check (so the error is emitted) but discards the result,
so the body is not tainted and later MIR optimizations run on malformed transmutes.
The other fix hunks (intrinsicck.rs returning Result, queries.rs signature) already exist in 1.99.1 and were left alone.
