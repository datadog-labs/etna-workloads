# Rationale

The 55.2.0 encode/decode already contain the fix's refactor (coercible signature, `encode_array`/`decode_array`), so the pre-fix
bug is reintroduced where it manifested: Large input types producing non-Large output.

Pre-fix, `encode(LargeBinary)` was planned as `LargeUtf8` but executed with a `Utf8` result (the error quoted in the fix's
commit message: "Function 'encode' returned value of type 'Utf8' while ... 'LargeUtf8' was promised").

Changes in `datafusion/functions/src/encoding/inner.rs`:
- `encode_array`, `DataType::LargeBinary` arm: `OutputOffset` changed `i64` -> `i32`, so the result is a `StringArray` (Utf8)
  while `EncodeFunc::return_type` still promises `LargeUtf8`. This undoes the fix's "Large types output Large arrays" handling.
- `decode_array`, `DataType::LargeBinary` arm: same `i64` -> `i32` change, giving `Binary` while `DecodeFunc::return_type`
  promises `LargeBinary`.

Oracle: `encoding.slt` fails; the `encode(arrow_cast(..., 'LargeBinary'), 'base64')` queries (and the decode LargeBinary
queries) raise the "returned value of type 'Utf8' while ... 'LargeUtf8' promised" internal error.
