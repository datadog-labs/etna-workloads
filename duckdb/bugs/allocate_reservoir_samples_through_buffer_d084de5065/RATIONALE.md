# allocate_reservoir_samples_through_buffer_d084de5065

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d084de5065cfd215d917724736063e1c98302175 ("Allocate reservoir samples through the buffer allocator"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/sample/reservoir_sample_memory_limit.test
