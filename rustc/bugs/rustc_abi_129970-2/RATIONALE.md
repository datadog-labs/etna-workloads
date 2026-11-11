# Adapted injection for layout computation: eagerly error for unexpected unsized fields

Fix: https://github.com/rust-lang/rust/commit/697450151c0b674eae406a4d1e0854e9386ac7ea

# Rationale
Single hunk: compiler/rustc_abi/src/layout.rs, `LayoutCalculator::univariant_biased` field loop.
The fix (hunks around `@@ -203,..` in layout.rs, rewriting layout_of_struct/univariant to return
`Err(LayoutCalculatorError::UnexpectedUnsized)` instead of the old `delayed_bug` + continue/`None`)
made unexpected unsized fields (in non-last position, or in AlwaysSized structs) an eager `Err`.
In 1.99.1 that is the `if let Some(unsized_field) ... return Err(UnexpectedUnsized)` and
`if field.is_unsized() { if MaybeUnsized {..} else { return Err(..) } }` code. I removed both errors
and just record `unsized_field = Some(field)` for any unsized field, so layout_of returns Ok with an
unsized layout where a sized one was expected (the pre-fix behaviour, issues #123134/#124182).
