# Rationale

Hunk: src/execution/join_hashtable.cpp, `JoinHashTable::EncodeDictSurvivingColumn`.
Traces to the fix's `EncodeDictSurvivingColumn` hunk that stores the reserved NULL index for NULL-only chunks.
I removed the `if (!VectorOperations::HasNotNull(incoming)) { ...null index... }` branch. A NULL-only chunk (the
unmatched-build scan of a FULL/RIGHT join) now falls through to the "non-dictionary chunk" InternalException.
This matches the original #26911 failure.

Oracle result (`./bin/etna-check`):
```
FAIL     test/sql/join/hash_join/hash_join_dict_surviving_outer_build.test
         ...:32 Query unexpectedly failed
         INTERNAL Error: dict-surviving join: narrowed column 0 received a non-dictionary chunk with values; build pipeline is not single-source
1 of 1 oracle units fail
```
