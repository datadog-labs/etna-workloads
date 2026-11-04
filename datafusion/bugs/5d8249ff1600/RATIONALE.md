# Rationale

Only one fix hunk is still behaviourally relevant in 55.2.0 (the others are error-message wording and arg-check merging, which are not bugs).

## Hunk reversed: `extract_seed` in `datafusion/spark/src/function/array/shuffle.rs`
The fix changed `ScalarValue::Null => None` to `ScalarValue::Null | ScalarValue::Int64(None) => None`, so a typed NULL seed is treated as "no seed". I restored the pre-fix arm `ScalarValue::Null => None`. A NULL seed coerced to `Int64(None)` now falls into the error arm: "shuffle seed must be Int64 type but got 'Int64'".

## Oracle failures
`spark/array/shuffle.slt` fails on both cases added by the fix: `SELECT shuffle(['ab'], NULL)` (line 110) and `SELECT shuffle(shuffle([3, 3], NULL), NULL)` (line 115). Both return the spurious error instead of the array.
