# Re-introduced bug: CompressionType sentinel named COMPRESSION_COUNT, hardcoded size 17

Hunks (reverse of fix):
- src/include/duckdb/common/enums/compression_type.hpp: last enumerator `ENUM_SIZE` -> `COMPRESSION_COUNT` (fix hunk 3).
- src/common/enums/compression_type.cpp ListCompressionTypes: uses `CompressionType::COMPRESSION_COUNT` (fix hunk 2).
- src/common/enum_util.cpp: values table last entry is `COMPRESSION_COUNT`/"COMPRESSION_COUNT"; ToChars/FromString use hardcoded 17 (fix hunk 1). With 17 entries the sentinel string is accepted by FromString as a valid value.
- src/main/settings/custom_settings.cpp: case label renamed to keep build green (needed consequence of the rename).

Result: `compression_count` parses to the sentinel (value 16) instead of "unrecognized value", then fails later with an internal error.

etna-check:
FAIL test/sql/storage/compression/compression_count_sentinel.test
  CREATE TABLE t (i INTEGER USING COMPRESSION compression_count);
  INTERNAL Error: Unrecognized compression type!
1 of 1 oracle units fail
