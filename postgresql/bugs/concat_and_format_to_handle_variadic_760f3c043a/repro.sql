select concat(variadic array[1,2,3]);
select concat_ws(',', variadic array[1,2,3]);
select concat(variadic NULL::int[]) is NULL;
select format('%s %s', variadic array['a','b']);
