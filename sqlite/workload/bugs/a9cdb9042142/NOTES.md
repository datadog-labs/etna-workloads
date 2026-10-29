repro.sql runs the autoindex-1110/1120 queries from test/autoindex1.test (LEFT JOIN with an automatic index on t3/t2).
Clean shell: both queries return `1|1|1|2||`.
Buggy shell: the first query returns `1|1|||abc|def`, and the second returns no row. The buggy auto-index/partial-index constraint check wrongly treats ON-clause terms as constraints on the table, so rows are filtered incorrectly.
