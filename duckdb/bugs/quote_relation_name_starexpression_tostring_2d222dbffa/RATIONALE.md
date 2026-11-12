# quote_relation_name_starexpression_tostring_2d222dbffa

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 2d222dbffa6685bfba3e739601ab267f36d6a463 ("Quote the relation name in StarExpression::ToString"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/parser/statement_tostring_roundtrip.test
