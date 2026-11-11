# Adapted injection for Handle not all immediates having `abi::Scalar`s

Fix: https://github.com/rust-lang/rust/commit/d757c4b904869967f1e665dc2bb9a2ca5122bc96

# Rationale
File: compiler/rustc_codegen_ssa/src/mir/rvalue.rs, fn `codegen_transmute_operand`.
Removed the arm `_ if cast.is_zst() => OperandValue::ZeroSized,` from the transmute match.

The fix's hunk 1 (`@@ -223,13 +223,21 @@ ... cast_immediate`) added `(ScalarOrZst::Zst, ScalarOrZst::Zst) => Some(OperandRef::new_zst(bx, cast).val)`
so ZST->ZST transmutes (issue 109992, `() -> [(); 1]`) are handled without needing a Scalar ABI. Hunks 2/3 (ScalarOrZst enum, `_ if layout.is_zst() => ScalarOrZst::Zst`)
supported that. In 1.99.1 the equivalent ZST handling is this single arm; removing it restores the pre-fix behaviour of not special-casing ZSTs
(they fall to the generic temp-alloca path, so extra alloca/lifetime code is emitted and `check_issue_109992` fails).
