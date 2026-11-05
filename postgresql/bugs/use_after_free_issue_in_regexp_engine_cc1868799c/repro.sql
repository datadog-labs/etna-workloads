select regexp_split_to_array('abcxxxdefyyyghi', '((.))(\1\2)');
select 'xyy' ~ '((.))(\2)' as t;
