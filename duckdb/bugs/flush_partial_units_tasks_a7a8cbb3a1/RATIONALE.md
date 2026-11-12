# flush_partial_units_tasks_a7a8cbb3a1

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a7a8cbb3a147fd160032221429c33d5ecaaf9a82 ("Flush partial units in tasks"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_query_result_format.cpp::A format given at submission reaches every completed result
- cpp:test/api/test_query_result_format.cpp::A payload fetched from a retained TestFormat result outlives the result, connection, and database
- cpp:test/api/test_query_result_format.cpp::A retained result in a format keeps its units in order
- cpp:test/api/test_query_result_format.cpp::A stream and an accessor refuse a format that is not the settled one
- cpp:test/api/test_query_result_format.cpp::A throw while flushing a partial unit surfaces as the result's error
- cpp:test/api/test_query_result_format.cpp::AppendToUnit runs exactly once per chunk, for a drained and a retained run
- cpp:test/api/test_query_result_format.cpp::Empty partitions under a parallel retained sink in a format
- cpp:test/api/test_query_result_format.cpp::Fetch resumes where it left off across a Collection call, and stays null after exhaustion, for a format
- cpp:test/api/test_query_result_format.cpp::Fetching from a retained format collection copies units out of an unchanged store
- cpp:test/api/test_query_result_format.cpp::Retained batch-ordered TestFormat with a cap below a row group
- cpp:test/api/test_query_result_format.cpp::Retained unordered and source-ordered TestFormat plans complete with every row
- cpp:test/api/test_query_result_format.cpp::RowCount throws after TakeCollection for a format
- cpp:test/api/test_query_result_format.cpp::SOURCE_ORDERED has exactly one local state under threads=4, drained and retained
- cpp:test/api/test_query_result_format.cpp::Slicing at the cap finishes several units from one append
- cpp:test/api/test_query_result_format.cpp::TakeCollection hands over the whole format store, fetched units included
- cpp:test/api/test_query_result_format.cpp::The Connection Query and Submit format overloads reach the format
- cpp:test/api/test_query_result_format.cpp::ToString, ToBox, Equals and FetchRaw on a retained TestFormat result pin today's behavior
