# Rationale

Fix (#14087): `encode` coerced Binary/LargeBinary input to Utf8/LargeUtf8 (`coerce_types`), so
binary that is not valid UTF-8 failed in the cast; `return_type` echoed the input type.

In 55.2.0 (`datafusion/functions/src/encoding/inner.rs`) the coercion is in `EncodeFunc::new`'s signature:
- Hunk `coerce_types` (Binary -> Utf8, LargeBinary -> LargeUtf8): first argument coercion changed from
  "Binary, implicitly accepting strings" to "string, implicitly accepting Binary" (`NativeType::String`),
  so binary is cast to string again (arrow cast validates UTF-8 and errors).
- Hunk `return_type`: LargeUtf8 input now returns LargeUtf8 (needed because strings now reach encode).
- `encode_scalar`/`encode_array`: added Utf8/Utf8View/LargeUtf8 branches (encode the string's bytes),
  required since the function now receives string arrays, as pre-fix.

Side effect: FixedSizeBinary input is no longer coercible (collateral, also shown failing).

Oracle: encoding.slt fails; encode of the non-UTF-8 binary column (row 3, X'8f50d3...') errors on the
Binary->Utf8 cast, and the FixedSizeBinary encode cases fail with planning errors.
