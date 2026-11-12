.mode list
.nullvalue NULL
CREATE TABLE l(a INTEGER[], b INTEGER[]);
INSERT INTO l VALUES ([NULL], [3]), ([NULL, 1], [1, 1]), ([3, 2, NULL], [3, 2, 3]),
                     ([NULL, NULL, NULL], [1, 2, 1]), ([2, 1], [2, NULL]),
                     ([NULL], [NULL]), ([1, NULL, 3], [1, NULL, 3]), (NULL, [1]), ([1], NULL);
SELECT a, b, a = b FROM l;
