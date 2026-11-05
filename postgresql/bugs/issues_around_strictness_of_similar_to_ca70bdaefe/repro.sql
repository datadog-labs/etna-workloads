SELECT 'abcdefg' SIMILAR TO '_bcd%' ESCAPE NULL AS null;
SELECT substring('abcdefg' SIMILAR 'a#"%#"g' ESCAPE NULL) AS null2;
