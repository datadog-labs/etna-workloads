set statement_timeout='3s';
SELECT substring('abcdefg' SIMILAR 'a*#"%#"g*' ESCAPE '#') AS r;
select 'abc' ~ '(^|x)*abc' as r2;
select 'ab' ~ '((a|)|b)*c' as r3;
