Adds a column with DEFAULT 9 via ALTER TABLE to a table with existing rows, then runs
`SELECT a, sum(b) FROM t2 GROUP BY a`. Clean shell: `1|18` and `2|9`. Buggy shell: the
GROUP BY sorter reads the raw column without default expansion, so b is NULL and sum(b) is NULL.
