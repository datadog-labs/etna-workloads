.mode list
.nullvalue NULL
SELECT try_cast({'tag': 5::UTINYINT, 'a': 1, 'b': NULL::VARCHAR} AS UNION(a INT, b VARCHAR));
