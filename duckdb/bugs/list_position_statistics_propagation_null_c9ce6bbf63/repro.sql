.mode list
.nullvalue NULL
SELECT a, list_position(a, NULL) IS NOT NULL
FROM VALUES ([2, 2, 3, NULL, NULL]), (NULL), ([]::INTEGER[]), ([NULL]) df(a);
