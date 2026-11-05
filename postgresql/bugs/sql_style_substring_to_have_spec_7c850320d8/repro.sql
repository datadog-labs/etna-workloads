SELECT SUBSTRING('abcdefg' SIMILAR 'a*#"%#"g*' ESCAPE '#') AS a;
SELECT SUBSTRING('abcdefg' SIMILAR 'a|b#"%#"g' ESCAPE '#') AS b;
SELECT SUBSTRING('abcdefg' SIMILAR 'a#"%#"g*#"x' ESCAPE '#') AS err;
