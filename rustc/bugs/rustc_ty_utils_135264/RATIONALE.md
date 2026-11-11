# Adapted injection for Consider more erroneous layouts as LayoutError::ReferencesError to suppress spurious errors

Fix: https://github.com/rust-lang/rust/commit/b89a6e49329f0813af07fa3f8472fb0333a8bc36

All changes in compiler/rustc_ty_utils/src/layout.rs, reverting to `LayoutError::Unknown(ty)` instead of `ReferencesError(guar)`:
- `map_error`, `LayoutCalculatorError::EmptyUnion` — fix hunk `@@ -105,21 +105,27 @@` (`let guar = ...delayed_bug("computed layout of empty union"); ReferencesError(guar)`).
- `map_error`, `LayoutCalculatorError::ReprConflict` — same hunk (`computed impossible repr (packed enum?)`).
- `layout_of_uncached`, union packed+aligned check — fix hunk `@@ -567,11 +575,11 @@` (`union cannot be packed and aligned`).
Other hunks (simd, unsized field) don't map onto 1.99.1 code as-is and were left alone.
