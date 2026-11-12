.mode list
.nullvalue NULL
PRAGMA explain_output = OPTIMIZED_ONLY;
CREATE TABLE nocase_strings(s VARCHAR COLLATE NOCASE);
INSERT INTO nocase_strings VALUES ('Abc'), ('abc'), ('xA'), ('xa'), ('Axxc');
SELECT s
FROM nocase_strings
WHERE regexp_matches(s, 'A')
ORDER BY s, s COLLATE C;
