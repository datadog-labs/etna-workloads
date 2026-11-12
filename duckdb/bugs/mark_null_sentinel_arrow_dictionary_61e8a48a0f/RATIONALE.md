# mark_null_sentinel_arrow_dictionary_61e8a48a0f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 61e8a48a0f58b802aacaef6672e34af569eb2fe5 ("Mark the NULL sentinel of an Arrow dictionary NULL in its struct and array children"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/arrow/arrow_dictionary_sentinel.cpp::Arrow scan of dict-encoded STRUCT column inside a STRUCT with NULL sentinel
- cpp:test/arrow/arrow_dictionary_sentinel.cpp::Arrow scan of dict-encoded STRUCT column with NULL sentinel
- cpp:test/arrow/arrow_dictionary_sentinel.cpp::Arrow scan of dict-encoded STRUCT column with a null type field and NULL sentinel
