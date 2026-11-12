.mode list
.nullvalue NULL
SET explain_output='optimized_only';
CREATE TABLE l_topn_dup(id INTEGER, k INTEGER, p VARCHAR);
CREATE TABLE r_topn_dup(k INTEGER, s INTEGER);
INSERT INTO l_topn_dup VALUES (1, 1, 'x');
INSERT INTO r_topn_dup VALUES (1, 30), (1, 20), (1, 10);
SELECT id, p
FROM (
	SELECT l_topn_dup.id, l_topn_dup.p, r_topn_dup.s
	FROM l_topn_dup
	JOIN r_topn_dup ON l_topn_dup.k = r_topn_dup.k
) AS src
QUALIFY ROW_NUMBER() OVER (ORDER BY s DESC NULLS LAST) <= 2
ORDER BY ALL;
