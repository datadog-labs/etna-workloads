# Rationale

The fix made Spark `sha2` return lowercase hex (it had called `spark_hex`, which is uppercase). It also returned NULL for unsupported bit lengths and moved to Int32.
In 55.2.0, `datafusion/spark/src/function/hash/sha2.rs` was rewritten. It already uses Int32 and returns NULL for unknown bit lengths, and it hex-encodes directly with `encode_bytes`.
The `spark_sha2_hex` / `lowercase` flag introduced by the fix's `hex.rs` hunks is now `HexCase`.

Change: in `sha2.rs`, all 8 `encode_bytes(..., HexCase::Lower)` calls became `HexCase::Upper`.
This covers the scalar path and `sha2_binary_bitlen_iter`. It restores the pre-fix uppercase output, which is what the fix's `spark_sha2_hex(lowercase=true)` and `hex_bytes(.., lowercase)` hunks corrected.

Oracle: `spark/hash/sha2.slt` fails. Every digest query returns uppercase hex where lowercase is expected, for example `2C26B4...` instead of `2c26b4...`. `./check.sh` shows the failures.
