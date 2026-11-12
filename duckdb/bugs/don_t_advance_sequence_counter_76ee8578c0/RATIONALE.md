# don_t_advance_sequence_counter_76ee8578c0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 76ee8578c082dbb87ff46da165505c06ff128bbe ("Don't advance sequence counter when nextval fails on overflow"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/catalog/sequence/sequence_overflow.test
