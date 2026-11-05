SELECT similar_to_escape('[|a]%', '|');
SELECT 'ab' SIMILAR TO '[|a]%' ESCAPE '|' AS r;
