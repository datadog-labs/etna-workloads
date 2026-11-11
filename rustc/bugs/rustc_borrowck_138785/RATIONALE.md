# Adapted injection for add `TypingMode::Borrowck`

Fix: https://github.com/rust-lang/rust/commit/509a144eed84e6ccd1227cd0d90f877a774aae70

# Rationale
One hunk: `compiler/rustc_borrowck/src/lib.rs`, `BorrowckInferCtxt::new`.
Re-expresses the fix hunk `@@ -431,7 +425,12 @@ impl<'tcx> BorrowckInferCtxt<'tcx>`, which replaced
`tcx.infer_ctxt().build(TypingMode::analysis_in_body(tcx, def_id))` with a choice
`if tcx.use_typing_mode_borrowck() { TypingMode::borrowck(..) } else { analysis_in_body }`.
In 1.99.1 the mode is `PostTypeckUntilBorrowck` (via `TypingMode::borrowck`, gated by
`use_typing_mode_post_typeck_until_borrowck`). The bug reintroduces the old behaviour: MIR borrowck always
uses `TypingMode::analysis_in_body`, so opaque hidden types are not seeded from HIR typeck.
