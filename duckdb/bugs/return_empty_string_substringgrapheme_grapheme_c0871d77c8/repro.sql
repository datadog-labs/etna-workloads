.mode list
.nullvalue NULL
CREATE TABLE strings(s VARCHAR);
INSERT INTO strings VALUES ('twoñthree₡four🦆end');
SELECT substring(s from 1 for 7) FROM strings;
SELECT substring(s from 10 for 7) FROM strings;
SELECT substring(s from 15 for 7) FROM strings;
SELECT substr(s, -4, 4) FROM strings;
SELECT substr(s, -1, -4) FROM strings;
SELECT substr(s, 0, -4) FROM strings;
SELECT substr(s, 0, 5) FROM strings;
SELECT substr(s, 5, -5) FROM strings;
SELECT substr(s, 5) FROM strings;
SELECT substr(s, -12345678, 12) FROM strings;
SELECT substr(s, -2147483648, 2) FROM strings;
SELECT substring_grapheme(s, -4, 4) FROM strings;
SELECT substring_grapheme(s, -1, -4) FROM strings;
SELECT substring_grapheme(s, 0, -4) FROM strings;
SELECT substring_grapheme(s, 0, 5) FROM strings;
SELECT substring_grapheme(s, 5, -5) FROM strings;
SELECT substring_grapheme(s, 5) FROM strings;
SELECT substring_grapheme(s, -12345678, 12) FROM strings;
SELECT substring_grapheme(s, -2147483648, 2) FROM strings;
SELECT substring_grapheme('ääääää', -10, 2), substring_grapheme('ääääää', -10, 5), substring_grapheme('ääääää', -10, 6);
