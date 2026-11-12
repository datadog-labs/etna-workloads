# Rationale

File: src/src/function/table/arrow_conversion.cpp, `ArrowToDuckDBConversion::ColumnArrowToDuckDBDictionary`
(inside the `array_state.CacheOutdated(array.dictionary)` block that builds the dictionary base vector).

Hunks (all trace to the single fix hunk): the dictionary's `SetValidityMask` call and the three recursive
calls (`ColumnArrowToDuckDBDictionary`, `ColumnArrowToDuckDBRunEndEncoded`, `ColumnArrowToDuckDB`) on
`*array.dictionary` once again pass the outer `chunk_offset` instead of `0`. The dictionary is a separate
array indexed from 0, so when the importer splits a column into several chunks, chunk 2+ reads the
dictionary from the wrong offset (wrong values / validity, or out-of-range reads), and the dictionary is cached
with that wrong offset. (v2.0.0 has no `SetInvalid(dict_length)` line, so none was touched.)

## Result
`./bin/etna-check`: 1 of 34 oracle units fail:
`FAIL cpp:test/api/capi/v2/test_capi_v2_arrow.cpp::V2 arrow: a dictionary column survives an importer split`
(REQUIRE failure in test_capi_v2.hpp / arrow test). The other 33 listed units still pass here (they don't exercise this path).
