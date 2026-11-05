CREATE COLLATION case_insensitive (provider = icu, locale = 'und-u-ks-level2', deterministic = false);
SELECT 'AB' LIKE '\ab' COLLATE case_insensitive AS t;
SELECT 'AB' LIKE '\a%' COLLATE case_insensitive AS t;
