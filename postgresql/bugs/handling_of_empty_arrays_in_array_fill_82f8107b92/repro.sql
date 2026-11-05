select a, a = '{}' as is_eq, array_dims(a) from (select array_fill(42, '{}') as a) ss;
select array_fill(1, array[2,2], '{}');
