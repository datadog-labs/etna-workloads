select array_remove(array['X','X','X'], 'X') = '{}';
select array_dims(array_remove(array[1,1],1)) is null as dims_null;
