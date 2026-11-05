select 'Programmer' ~ '(\w).*?\1' as t;
select regexp_matches('Programmer', '(\w)(.*?\1)', 'g');
