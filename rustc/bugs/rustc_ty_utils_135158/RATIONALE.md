# Adapted injection for Add `TooGeneric` variant to `LayoutError` and emit `Unknown` one

Fix: https://github.com/rust-lang/rust/commit/cef97bce7b2a0e6ef2208aaa1ec267b800d646af

# Re-injection

One hunk: `compiler/rustc_ty_utils/src/layout.rs`, `map_error`, arm `LayoutCalculatorError::UnexpectedUnsized`.

Re-expresses the fix hunk `@@ -104,14 +104,12 @@ fn map_error<'tcx>(`, which replaced
`if !field.ty.is_sized(cx.tcx(), cx.typing_env) { delayed_bug(..); ReferencesError(guar) } else { Unknown(ty) }`
with
`if cx.typing_env.param_env.caller_bounds().is_empty() { delayed_bug(..) } LayoutError::Unknown(ty)`.
I restored the old form. An unsized field with a non-Sized type now raises a delayed bug and returns `ReferencesError`.

The other hunks of the fix (the `TooGeneric` variant etc.) are already present in 1.99.1, so they were not touched.
