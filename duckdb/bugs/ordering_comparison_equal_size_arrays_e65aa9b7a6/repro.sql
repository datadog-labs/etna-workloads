.mode list
.nullvalue NULL
CREATE TABLE arr_test (arr INT[3]);
INSERT INTO arr_test VALUES (ARRAY[1,2,3]::INT[3]), (ARRAY[1,2,4]::INT[3]), (ARRAY[1,2,2]::INT[3]);
SELECT
	count(*) FILTER (arr > ARRAY[1,2,3]::INT[3]),
	count(*) FILTER (arr >= ARRAY[1,2,3]::INT[3]),
	count(*) FILTER (arr < ARRAY[1,2,3]::INT[3]),
	count(*) FILTER (arr <= ARRAY[1,2,3]::INT[3]),
	count(*) FILTER (arr = ARRAY[1,2,3]::INT[3]),
	count(*) FILTER (arr <> ARRAY[1,2,3]::INT[3]),
FROM arr_test;
SELECT count(*) FROM arr_test WHERE arr > ARRAY[1,2,3]::INT[3] AND arr = ARRAY[1,2,3]::INT[3];
