repro.sql runs `encode` and `decode` (hex) on a `LargeBinary` input.

- df-clean returns the encoded and decoded values.
- df-buggy fails both queries with an internal error. The injection uses i32 offsets for the LargeBinary case, so the functions return Utf8/Binary instead of the planned LargeUtf8/LargeBinary.
