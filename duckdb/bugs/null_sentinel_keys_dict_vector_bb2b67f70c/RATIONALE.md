# null_sentinel_keys_dict_vector_bb2b67f70c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit bb2b67f70c2ab6ab15762604bf51def859c2d992 ("Fix null sentinel for keys in dict vector (Arrow)"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/arrow/arrow_dictionary_sentinel.cpp::Arrow scan of dict-encoded STRUCT column inside a STRUCT with NULL sentinel
- cpp:test/arrow/arrow_dictionary_sentinel.cpp::Arrow scan of dict-encoded STRUCT column with NULL sentinel
- cpp:test/arrow/arrow_dictionary_sentinel.cpp::Arrow scan of dict-encoded column with an unknown null count
- cpp:test/arrow/arrow_dictionary_sentinel.cpp::Arrow scan of dict-encoded int32 column with NULL sentinel
